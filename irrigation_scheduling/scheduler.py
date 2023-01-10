import requests
import numpy as np
from datetime import date, timedelta



def get_pth_percentile(array, percentile):
    sorted = np.sort(array)

    ith = int((percentile/100)*(len(array)-1))

    return sorted[ith]

###############################################################################################################################################
###############################################################################################################################################

def increase_irrigation_alert(forecasted_data, notifications, today = 1):
    alerts = {}
    alert_type = {}
    alert_type['temperature_2m'] = 'high temperature'
    alert_type['relativehumidity_2m'] = 'low humidity'
    alert_type['windspeed_10m'] = 'high windspeed'
    day = 0


    for i, row in enumerate(zip(forecasted_data['temperature_2m'], forecasted_data['relativehumidity_2m'], forecasted_data['windspeed_10m'])):
        if(i%24 == 0):
            day += 1
            alerts[day] = {}
            alerts[day]['temperature_2m'] = []
            alerts[day]['relativehumidity_2m'] = []
            alerts[day]['windspeed_10m'] = []
            
        if(row[0] > high_thresholds['temperature_2m']):
            alerts[day]['temperature_2m'].append(forecasted_data['time'][i])

        if(row[1] < low_thresholds['relativehumidity_2m']):
            alerts[day]['relativehumidity_2m'].append(forecasted_data['time'][i])

        if(row[2] > high_thresholds['windspeed_10m']):
            alerts[day]['windspeed_10m'].append(forecasted_data['time'][i])

    for i in range(1, 8):
        current_day = int_to_week[(today+i-2)%7+1]
        for type in alerts[i]:
            res = {}
            if(alerts[i][type] != []):
                intervals = investigate_one_day(alerts[i][type])
                if(intervals == []): continue
                res['hours'] = intervals
                res['type'] = 'increase irrigation'
                res['reason'] = alert_type[type]
                notifications[current_day].append(res)


###############################################################################################################################################
###############################################################################################################################################

def decrease_irrigation_alert(forecasted_data, notifications, today = 1):
    alerts = {}
    alert_type = {}
    alert_type['precipitation'] = 'high precipitation'
    alert_type['soil_moisture_9_27cm'] = 'high soil moisture'
    day = 0
    for i, row in enumerate(zip(forecasted_data['precipitation'], forecasted_data['soil_moisture_9_27cm'])):
        if(i%24 == 0):
            day += 1
            alerts[day] = {}
            alerts[day]['precipitation'] = []
            alerts[day]['soil_moisture_9_27cm'] = []
        if(row[0] > high_thresholds['precipitation']):
            alerts[day]['precipitation'].append(forecasted_data['time'][i])

        if(row[1] > high_thresholds['soil_moisture_7_to_28cm']):
            alerts[day]['soil_moisture_9_27cm'].append(forecasted_data['time'][i])

    for i in range(1, 8):
        current_day = int_to_week[(today+i-2)%7+1]
        for type in alerts[i]:
            res = {}
            if(alerts[i][type] != []):
                intervals = investigate_one_day(alerts[i][type])
                if(intervals == []): continue
                res['hours'] = intervals
                res['type'] = 'decrease irrigation'
                res['reason'] = alert_type[type]
                notifications[current_day].append(res)


###############################################################################################################################################
###############################################################################################################################################

def frost_warning(forecasted_data, notifications, today = 1):
    # hours, recommendation type, reason
    for i in range(0, 7):
        current_day = int_to_week[(today+i-1)%7+1]
        start_index = i*24
        avg_degree = sum(forecasted_data['temperature_2m'][start_index:start_index+8])/8
        avg_dew = sum(forecasted_data['dewpoint_2m'][start_index:start_index+8])/8
        avg_wind = sum(forecasted_data['windspeed_10m'][start_index:start_index+8])/8
        avg_cloud = sum(forecasted_data['cloudcover'][start_index:start_index+8])/8

        temp_wind_threshold = 5
        temp_cloud_threshold = 50

        res = {}
        if(avg_degree < 4.4 and avg_dew < 4.4 and avg_wind < temp_wind_threshold and avg_cloud < temp_cloud_threshold):
            res['type'] = 'frost is expected'
            res['reason'] = 'low temperature, dew, wind speed, cloud'
            notifications[current_day].append(res)


###############################################################################################################################################
###############################################################################################################################################


def hour(time_string):
    return int(time_string[-5:-3])

def investigate_one_day(day_message):
    if(len(day_message) == 0): return []
    message_intervals = []

    i = 0
    current_first_end = day_message[i]
    while(True):
        current_last_end = day_message[i]
        if(i >= len(day_message)-1):
            ############## CHANGEABLE ##############
            if(hour(current_last_end) - hour(current_first_end) > 3): message_intervals.append((current_first_end, current_last_end))
            ########################################

            break
        if(hour(day_message[i]) + 1 != hour(day_message[i+1])):
            ############## CHANGEABLE ##############
            if(hour(current_last_end) - hour(current_first_end) > 3): message_intervals.append((current_first_end, current_last_end))
            ########################################

            current_first_end = day_message[i+1]
        i += 1

    return message_intervals

# def recommend(alert_message, alert_message_types, given_message = 'You may consider decreasing irrigation', today = 1):
#     for i in range(1, 8):
#         current_day = int_to_week[(today+i-2)%7+1]
#         print(f'\nNotifications for {current_day}:')
#         for type in alert_message[i]:
#             if(alert_message[i][type] != []):
#                 print(f'In the following hours the {type} is {alert_message_types[type]}:')
#                 intervals = investigate_one_day(alert_message[i][type])
#                 for interval in intervals:
#                     print(f'between {interval[0]} - {interval[1]}')
#                 print(given_message)


###############################################################################################################################################
###############################################################################################################################################



if __name__ == "__main__":

    # TAKE THE LAST MONTH'S HISTORICAL DATA AND 1 WEEK FORECASTED DATA FROM THE API.

    FORECAST_URL = 'https://api.open-meteo.com/v1/forecast'

    HISTORICAL_DATA_URL = 'https://archive-api.open-meteo.com/v1/era5'


    current_day = date.today()

    to_date = current_day - timedelta(days=7)
    TODAY_DATE = to_date.strftime("%Y-%m-%d")
    # TODAY_DATE = '2023-01-03'

    la_date = current_day - timedelta(days=37)
    LAST_MONTH_DATE = la_date.strftime("%Y-%m-%d")
    # LAST_MONTH_DATE = '2022-12-01'


    int_to_week = {1: 'Monday', 2: 'Tuesday', 3: 'Wednesday', 4: 'Thursday', 5: 'Friday', 6: 'Saturday', 7: 'Sunday'}
    week_to_int = {'Monday':1, 'Tuesday':2, 'Wednesday':3, 'Thursday':4, 'Friday':5, 'Saturday':6, 'Sunday':7}
    notifications = {'Monday':[], 'Tuesday':[], 'Wednesday':[], 'Thursday':[], 'Friday':[], 'Saturday':[], 'Sunday':[]}


    TODAY = int_to_week[current_day.weekday() + 1]
    # TODAY = 'Tuesday'
    print(f'todate: {to_date} \t ladate: {la_date}, \t today: {TODAY}')


    FORECAST_PARAMS = {
        'latitude':39.9439,
        'longitude': 32.8560,
        'timezone': 'auto',
        'hourly': ['temperature_2m', 'relativehumidity_2m', 'dewpoint_2m', 'precipitation', 'rain', 'windspeed_10m', 'winddirection_10m', 'soil_moisture_9_27cm', 'cloudcover']
    }

    HISTORICAL_PARAMS = {
        'latitude':39.9439,
        'longitude': 32.8560,
        'hourly': ['temperature_2m', 'relativehumidity_2m', 'dewpoint_2m', 'precipitation', 'rain', 'windspeed_10m', 'soil_moisture_7_to_28cm', 'cloudcover']
    }

    forecast_r = requests.get(url = FORECAST_URL, params = FORECAST_PARAMS)

    HISTORICAL_PARAMS['start_date'] = LAST_MONTH_DATE
    HISTORICAL_PARAMS['end_date'] = TODAY_DATE

    historical_r = requests.get(url = HISTORICAL_DATA_URL, params = HISTORICAL_PARAMS)

    forecast_data = forecast_r.json()
    historical_data = historical_r.json()


    ###############################################################################################################################################
    ###############################################################################################################################################

    # GET HIGH AND LOW THRESHOLDS BASED ON THE LAST MONTH'S DATA. THRESHOLDS ARE SET TO 90TH AND 10TH QUANTILES.

    high_thresholds = {}
    for i in historical_data['hourly']:
        high_thresholds[i] = get_pth_percentile(historical_data['hourly'][i], 90)

    low_thresholds = {}
    for i in historical_data['hourly']:
        low_thresholds[i] = get_pth_percentile(historical_data['hourly'][i], 10)


    ###############################################################################################################################################
    ###############################################################################################################################################

    increase_irrigation_alert(forecast_data['hourly'], notifications, today=week_to_int[TODAY])
    decrease_irrigation_alert(forecast_data['hourly'], notifications, today=week_to_int[TODAY])
    frost_warning(forecast_data['hourly'], notifications, today = week_to_int[TODAY])

    for i in notifications:
        print(f'\n{i}:')
        for j in notifications[i]:
            print(j)
    # print('\n##############################################')
    # recommend(decrease_irrigation, decrease_irrigation_type, given_message = 'DECREASE SULAMAA AQKKKK', today = week_to_int[TODAY])
    # print('\n##############################################')
    #recommend(increase_irrigation, increase_irrigation_type, given_message = 'ARTTIR KARDES BIRAZ OLDUK AK', today = week_to_int[TODAY])


    pass