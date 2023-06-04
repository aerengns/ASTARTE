import random
from datetime import datetime, timedelta

import requests
from django.core.management.base import BaseCommand
from django.utils import timezone
from firebase_admin import messaging
from backendcore.models import Farm, FarmCornerPoint

from accounts.models import DeviceToken
from calendarapp.models import Event


def get_pth_percentile(array, percentile):
    sorted_array = sorted(array)

    ith = int((percentile / 100) * (len(array) - 1))

    return sorted_array[ith]


def get_given_percentile(array, number):
    sorted_arr = sorted(array)

    if len(sorted_arr) != 0:
        for i in range(len(sorted_arr)):
            if sorted_arr[i] > number:
                return i/len(sorted_arr)
    return 1


def hour(time_string):
    return int(time_string[-5:-3])


def get_max_importance_hour(notification, type):
    max_import = -1
    max_hours = -1
    for element in notification:
        if element['type'] == type and element['importance'] >= max_import:
            max_import = element['importance']
            curr_hours = hour(element['hours'][0][1]) - \
                hour(element['hours'][0][0])
            if max_hours < curr_hours:
                max_hours = curr_hours

    return max_import, max_hours


def remove_events_with_type(notification, type):
    to_remove = []
    for i in range(len(notification)):
        if notification[i]['type'] == type:
            to_remove.append(i)

    for i in to_remove[::-1]:
        notification.pop(i)


def remove_conflicting_events(notifications):
    for day in notifications:
        notification = notifications[day]
        increase_importance, increase_hours = get_max_importance_hour(
            notification, type='increase irrigation')
        decrease_importance, decrease_hours = get_max_importance_hour(
            notification, type='decrease irrigation')
        if increase_importance > decrease_importance:
            remove_events_with_type(notification, 'decrease irrigation')
        elif decrease_importance > increase_importance:
            remove_events_with_type(notification, 'increase irrigation')
        elif increase_importance != -1:
            if increase_hours > decrease_hours:
                remove_events_with_type(
                    notification, 'decrease irrigation')
            else:
                remove_events_with_type(
                    notification, 'increase irrigation')


def investigate_one_day(day_message, alert_importance=None):
    if len(day_message) == 0:
        return []
    message_intervals = []
    alert_importance_intervals = []

    i = 0
    current_first_end = day_message[i]
    current_first_i = i
    while True:
        current_last_end = day_message[i]
        if i >= len(day_message) - 1:
            ############## HOUR THRESHOLD CHANGEABLE ##############
            if hour(current_last_end) - hour(current_first_end) > 3:
                message_intervals.append(
                    (current_first_end, current_last_end))
                alert_importance_intervals.append((current_first_i, i))

            break
        if hour(day_message[i]) + 1 != hour(day_message[i + 1]):
            ############## HOUR THRESHOLD CHANGEABLE ##############
            if hour(current_last_end) - hour(current_first_end) > 3:
                message_intervals.append(
                    (current_first_end, current_last_end))
                alert_importance_intervals.append((current_first_i, i))

            current_first_end = day_message[i + 1]
            current_first_i = i+1
        i += 1
    importance_avgs = []
    if(alert_importance is not None):
        for i in alert_importance_intervals:
            avg = 0
            for importance in alert_importance[i[0]:i[1]]:
                avg += importance
            importance_avgs.append(avg/(i[1]-i[0]))

    try:
        avg = sum(importance_avgs)/len(importance_avgs)
    except:
        avg = -1
    return message_intervals, avg


class Command(BaseCommand):
    help = 'Creates Calendar Events'

    def __init__(self, stdout=None, stderr=None, no_color=False, force_color=False):
        super().__init__(stdout, stderr, no_color, force_color)

        self.forecast_data = dict()
        self.historical_data = dict()
        # TAKE THE LAST MONTH'S HISTORICAL DATA AND 1 WEEK FORECASTED DATA FROM THE API.
        self.high_thresholds = dict()
        self.low_thresholds = dict()
        FORECAST_URL = 'https://api.open-meteo.com/v1/forecast'
        HISTORICAL_DATA_URL = 'https://archive-api.open-meteo.com/v1/era5'

        current_day = datetime.today()

        to_date = current_day - timedelta(days=350)
        TODAY_DATE = to_date.strftime("%Y-%m-%d")
        # TODAY_DATE = '2023-01-03'

        la_date = current_day - timedelta(days=380)
        LAST_MONTH_DATE = la_date.strftime("%Y-%m-%d")
        # LAST_MONTH_DATE = '2022-12-01'

        self.week_to_int = {}
        self.int_to_week = {}
        self.notifications = {}

        for i in range(1, 8):
            self.int_to_week[i] = current_day + timedelta(days=i - 1)
            self.week_to_int[current_day + timedelta(days=i - 1)] = i

        self.TODAY = self.int_to_week[current_day.weekday() + 1]

        # TODO: selfli seyler farm_id:value dictionarysi seklinde kullanilacak
        for farm in Farm.objects.all():
            # TODO: do stuff
            self.notifications[farm.id] = dict()
            for i in range(1, 8): 
                self.notifications[farm.id][current_day + timedelta(days=i - 1)] = []

            corner_points = FarmCornerPoint.objects.filter(farm=farm)
            # for corner_point in corner_points:
            #     farm_corners.append([corner_point.longitude, corner_point.latitude])

            # TODAY = 'Tuesday'

            FORECAST_PARAMS = {
                'latitude': corner_points[0].latitude,
                'longitude': corner_points[0].longitude,
                'timezone': 'auto',
                'hourly': ['temperature_2m', 'relativehumidity_2m', 'dewpoint_2m', 'precipitation', 'rain', 'windspeed_10m',
                        'winddirection_10m', 'soil_moisture_9_27cm', 'cloudcover']
            }

            HISTORICAL_PARAMS = {
                'latitude': corner_points[0].latitude,
                'longitude': corner_points[0].longitude,
                'hourly': ['temperature_2m', 'relativehumidity_2m', 'dewpoint_2m', 'precipitation', 'rain', 'windspeed_10m',
                        'soil_moisture_7_to_28cm', 'cloudcover']
            }

            forecast_r = requests.get(url=FORECAST_URL, params=FORECAST_PARAMS)

            HISTORICAL_PARAMS['start_date'] = LAST_MONTH_DATE
            HISTORICAL_PARAMS['end_date'] = TODAY_DATE

            historical_r = requests.get(
                url=HISTORICAL_DATA_URL, params=HISTORICAL_PARAMS)

            current_forecast_data = forecast_r.json()
            current_historical_data = historical_r.json()

            self.forecast_data[farm.id] = current_forecast_data
            self.historical_data[farm.id] = current_historical_data

            # GET HIGH AND LOW THRESHOLDS BASED ON THE LAST MONTH'S DATA. THRESHOLDS ARE SET TO 90TH AND 10TH QUANTILES.
            self.high_thresholds[farm.id] = dict()
            self.low_thresholds[farm.id] = dict()
            for i in current_historical_data['hourly']:
                self.high_thresholds[farm.id][i] = get_pth_percentile(
                    current_historical_data['hourly'][i], 90)

            for i in current_historical_data['hourly']:
                self.low_thresholds[farm.id][i] = get_pth_percentile(
                    current_historical_data['hourly'][i], 10)

    def frost_warning(self, today=1, farm_id=1):
        # hours, recommendation type, reason
        for i in range(0, 7):
            current_day = self.int_to_week[(today + i - 1) % 7 + 1]
            start_index = i * 24
            avg_degree = sum(
                self.forecast_data[farm_id]['hourly']['temperature_2m'][start_index:start_index + 8]) / 8
            avg_dew = sum(
                self.forecast_data[farm_id]['hourly']['dewpoint_2m'][start_index:start_index + 8]) / 8
            avg_wind = sum(
                self.forecast_data[farm_id]['hourly']['windspeed_10m'][start_index:start_index + 8]) / 8
            avg_cloud = sum(
                self.forecast_data[farm_id]['hourly']['cloudcover'][start_index:start_index + 8]) / 8

            # TODO: You may change these thresholds.
            temp_wind_threshold = 5
            temp_cloud_threshold = 50

            res = {}
            if (
                    avg_degree < 4.4 and avg_dew < 4.4 and avg_wind < temp_wind_threshold and avg_cloud < temp_cloud_threshold):
                res['type'] = 2
                res['reason'] = 'low temperature, dew, wind speed, cloud'
                res['importance'] = 2
                self.notifications[farm_id][current_day].append(res)

    def heat_stress_warning(self, today=1, farm_id=1):
        for i in range(0, 7):
            current_day = self.int_to_week[(today + i - 1) % 7 + 1]
            start_index = i * 24
            avg_degree = sum(
                self.forecast_data[farm_id]['hourly']['temperature_2m'][start_index:start_index + 8]) / 8

            high_temp_threshold = 40

            res = {}
            if avg_degree > high_temp_threshold:
                res['type'] = 3
                res['reason'] = 'high temperature'
                res['importance'] = 0
                self.notifications[farm_id][current_day].append(res)

    def increase_irrigation_alert(self, today=1, farm_id = 1):
        alerts = {}
        alerts_importance = {}
        alert_type = {'temperature_2m': 'high temperature', 'relativehumidity_2m': 'low humidity',
                      'windspeed_10m': 'high windspeed'}
        day = 0

        for i, row in enumerate(
                zip(self.forecast_data[farm_id]['hourly']['temperature_2m'], self.forecast_data[farm_id]['hourly']['relativehumidity_2m'],
                    self.forecast_data[farm_id]['hourly']['windspeed_10m'])):
            if i % 24 == 0:
                day += 1
                alerts[day] = {}
                alerts[day]['temperature_2m'] = []
                alerts[day]['relativehumidity_2m'] = []
                alerts[day]['windspeed_10m'] = []
                alerts_importance[day] = {}
                alerts_importance[day]["temperature_2m"] = []
                alerts_importance[day]["relativehumidity_2m"] = []
                alerts_importance[day]["windspeed_10m"] = []

            if row[0] > self.high_thresholds[farm_id]['temperature_2m']:
                alerts[day]['temperature_2m'].append(
                    self.forecast_data[farm_id]['hourly']['time'][i])
                alerts_importance[day]["temperature_2m"].append((get_given_percentile(
                    self.historical_data[farm_id]['hourly']['temperature_2m'], row[0])-0.9)*10)

            if row[1] < self.low_thresholds[farm_id]['relativehumidity_2m']:
                alerts[day]['relativehumidity_2m'].append(
                    self.forecast_data[farm_id]['hourly']['time'][i])
                alerts_importance[day]["relativehumidity_2m"].append(
                    (0.1-get_given_percentile(self.historical_data[farm_id]['hourly']['relativehumidity_2m'], row[1]))*10)

            if row[2] > self.high_thresholds[farm_id]['windspeed_10m']:
                alerts[day]['windspeed_10m'].append(
                    self.forecast_data[farm_id]['hourly']['time'][i])
                alerts_importance[day]["windspeed_10m"].append((get_given_percentile(
                    self.historical_data[farm_id]['hourly']['windspeed_10m'], row[2])-0.9)*10)

        for i in range(1, 8):
            current_day = self.int_to_week[(today + i - 2) % 7 + 1]
            for type in alerts[i]:
                res = {}
                if alerts[i][type]:
                    intervals, importance_avg = investigate_one_day(
                        alerts[i][type], alerts_importance[i][type])

                    if not intervals:
                        continue
                    # TODO: hours integration
                    res['hours'] = intervals
                    res['type'] = 0
                    res['reason'] = alert_type[type]
                    res['importance'] = round(2*importance_avg)
                    self.notifications[farm_id][current_day].append(res)

    def decrease_irrigation_alert(self, today=1, farm_id=1):
        alerts = {}
        alerts_importance = {}
        alert_type = {'precipitation': 'high precipitation',
                      'soil_moisture_9_27cm': 'high soil moisture'}
        day = 0
        for i, row in enumerate(zip(self.forecast_data[farm_id]['hourly']['precipitation'],
                                    self.forecast_data[farm_id]['hourly']['soil_moisture_9_27cm'])):
            if i % 24 == 0:
                day += 1
                alerts[day] = {}
                alerts[day]['precipitation'] = []
                alerts[day]['soil_moisture_9_27cm'] = []
                alerts_importance[day] = {}
                alerts_importance[day]["precipitation"] = []
                alerts_importance[day]["soil_moisture_9_27cm"] = []
            if row[0] > self.high_thresholds[farm_id]['precipitation']:
                alerts[day]['precipitation'].append(
                    self.forecast_data[farm_id]['hourly']['time'][i])
                alerts_importance[day]["precipitation"].append((get_given_percentile(
                    self.historical_data[farm_id]['hourly']['precipitation'], row[0])-0.9)*10)

            if row[1] > self.high_thresholds[farm_id]['soil_moisture_7_to_28cm']:
                alerts[day]['soil_moisture_9_27cm'].append(
                    self.forecast_data[farm_id]['hourly']['time'][i])
                alerts_importance[day]["soil_moisture_9_27cm"].append((get_given_percentile(
                    self.historical_data[farm_id]['hourly']['soil_moisture_7_to_28cm'], row[1])-0.9)*10)

        for i in range(1, 8):
            current_day = self.int_to_week[(today + i - 2) % 7 + 1]
            for type in alerts[i]:
                res = {}
                if alerts[i][type]:
                    intervals, importance_avg = investigate_one_day(
                        alerts[i][type],  alerts_importance[i][type])
                    if not intervals:
                        continue
                    res['hours'] = intervals
                    res['type'] = 1
                    res['reason'] = alert_type[type]
                    res['importance'] = round(2*importance_avg)
                    self.notifications[farm_id][current_day].append(res)

    def handle(self, *args, **kwargs):

        events = []
        for farm in Farm.objects.all():
            self.increase_irrigation_alert(today=self.week_to_int[self.TODAY], farm_id = farm.id)
            self.decrease_irrigation_alert(today=self.week_to_int[self.TODAY], farm_id = farm.id)
            self.frost_warning(today=self.week_to_int[self.TODAY], farm_id = farm.id)

            remove_conflicting_events(self.notifications[farm.id])
            for i in self.notifications[farm.id]:
                for j in self.notifications[farm.id][i]:
                    importance = j['importance']
                    if importance==2:
                        self.send_notification(j['reason'])
                    events.append(Event(title=j['reason'], type=j['type'], date=i, importance=importance, farm_id=farm.id))
        
        Event.objects.bulk_create(events)

    def send_notification(self, body):
        # TODO: MAKE NOTIFICATION SPECIFIC TO FARM OWNER
        device_tokens = DeviceToken.objects.all()
        for device_token in device_tokens:
            title = 'Critical Event'
            message = messaging.Message(
                notification=messaging.Notification(
                    title=title,
                    body=body + ' is expected',
                    image='https://img.icons8.com/plumpy/512/important-event.png',
                ),
                token=device_token.token,
            )
            response = messaging.send(message)
            print('Successfully sent message:', message.notification)
