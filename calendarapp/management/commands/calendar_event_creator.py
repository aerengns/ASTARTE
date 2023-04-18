import random
from datetime import datetime, timedelta

import requests
from django.core.management.base import BaseCommand
from django.utils import timezone
from firebase_admin import messaging

from calendarapp.models import Event


def get_pth_percentile(array, percentile):
    sorted_array = sorted(array)

    ith = int((percentile / 100) * (len(array) - 1))

    return sorted_array[ith]


def hour(time_string):
    return int(time_string[-5:-3])


def investigate_one_day(day_message):
    if len(day_message) == 0: return []
    message_intervals = []

    i = 0
    current_first_end = day_message[i]
    while True:
        current_last_end = day_message[i]
        if i >= len(day_message) - 1:
            ############## CHANGEABLE ##############
            if hour(current_last_end) - hour(current_first_end) > 3: message_intervals.append(
                (current_first_end, current_last_end))
            ########################################

            break
        if hour(day_message[i]) + 1 != hour(day_message[i + 1]):
            ############## CHANGEABLE ##############
            if hour(current_last_end) - hour(current_first_end) > 3: message_intervals.append(
                (current_first_end, current_last_end))
            ########################################

            current_first_end = day_message[i + 1]
        i += 1

    return message_intervals


class Command(BaseCommand):
    help = 'Creates Calendar Events'

    def __init__(self, stdout=None, stderr=None, no_color=False, force_color=False):
        super().__init__(stdout, stderr, no_color, force_color)

        # TAKE THE LAST MONTH'S HISTORICAL DATA AND 1 WEEK FORECASTED DATA FROM THE API.
        self.high_thresholds = {}
        self.low_thresholds = {}
        FORECAST_URL = 'https://api.open-meteo.com/v1/forecast'
        HISTORICAL_DATA_URL = 'https://archive-api.open-meteo.com/v1/era5'

        current_day = datetime.today()

        to_date = current_day - timedelta(days=7)
        TODAY_DATE = to_date.strftime("%Y-%m-%d")
        # TODAY_DATE = '2023-01-03'

        la_date = current_day - timedelta(days=37)
        LAST_MONTH_DATE = la_date.strftime("%Y-%m-%d")
        # LAST_MONTH_DATE = '2022-12-01'

        self.week_to_int = {}
        self.int_to_week = {}
        self.notifications = {}

        for i in range(1, 8):
            self.int_to_week[i] = current_day + timedelta(days=i - 1)
            self.week_to_int[current_day + timedelta(days=i - 1)] = i
            self.notifications[current_day + timedelta(days=i - 1)] = []

        self.TODAY = self.int_to_week[current_day.weekday() + 1]
        # TODAY = 'Tuesday'

        FORECAST_PARAMS = {
            'latitude': 39.9439,
            'longitude': 32.8560,
            'timezone': 'auto',
            'hourly': ['temperature_2m', 'relativehumidity_2m', 'dewpoint_2m', 'precipitation', 'rain', 'windspeed_10m',
                       'winddirection_10m', 'soil_moisture_9_27cm', 'cloudcover']
        }

        HISTORICAL_PARAMS = {
            'latitude': 39.9439,
            'longitude': 32.8560,
            'hourly': ['temperature_2m', 'relativehumidity_2m', 'dewpoint_2m', 'precipitation', 'rain', 'windspeed_10m',
                       'soil_moisture_7_to_28cm', 'cloudcover']
        }

        forecast_r = requests.get(url=FORECAST_URL, params=FORECAST_PARAMS)

        HISTORICAL_PARAMS['start_date'] = LAST_MONTH_DATE
        HISTORICAL_PARAMS['end_date'] = TODAY_DATE

        historical_r = requests.get(url=HISTORICAL_DATA_URL, params=HISTORICAL_PARAMS)

        self.forecast_data = forecast_r.json()
        self.historical_data = historical_r.json()

        # GET HIGH AND LOW THRESHOLDS BASED ON THE LAST MONTH'S DATA. THRESHOLDS ARE SET TO 90TH AND 10TH QUANTILES.

        for i in self.historical_data['hourly']:
            self.high_thresholds[i] = get_pth_percentile(self.historical_data['hourly'][i], 90)

        for i in self.historical_data['hourly']:
            self.low_thresholds[i] = get_pth_percentile(self.historical_data['hourly'][i], 10)

    def frost_warning(self, today=1):
        # hours, recommendation type, reason
        for i in range(0, 7):
            current_day = self.int_to_week[(today + i - 1) % 7 + 1]
            start_index = i * 24
            avg_degree = sum(self.forecast_data['hourly']['temperature_2m'][start_index:start_index + 8]) / 8
            avg_dew = sum(self.forecast_data['hourly']['dewpoint_2m'][start_index:start_index + 8]) / 8
            avg_wind = sum(self.forecast_data['hourly']['windspeed_10m'][start_index:start_index + 8]) / 8
            avg_cloud = sum(self.forecast_data['hourly']['cloudcover'][start_index:start_index + 8]) / 8

            temp_wind_threshold = 5
            temp_cloud_threshold = 50

            res = {}
            if (
                    avg_degree < 4.4 and avg_dew < 4.4 and avg_wind < temp_wind_threshold and avg_cloud < temp_cloud_threshold):
                res['type'] = 1
                res['reason'] = 'low temperature, dew, wind speed, cloud'
                self.notifications[current_day].append(res)

    def increase_irrigation_alert(self, today=1):
        alerts = {}
        alert_type = {'temperature_2m': 'high temperature', 'relativehumidity_2m': 'low humidity',
                      'windspeed_10m': 'high windspeed'}
        day = 0

        for i, row in enumerate(
                zip(self.forecast_data['hourly']['temperature_2m'], self.forecast_data['hourly']['relativehumidity_2m'],
                    self.forecast_data['hourly']['windspeed_10m'])):
            if i % 24 == 0:
                day += 1
                alerts[day] = {}
                alerts[day]['temperature_2m'] = []
                alerts[day]['relativehumidity_2m'] = []
                alerts[day]['windspeed_10m'] = []

            if row[0] > self.high_thresholds['temperature_2m']:
                alerts[day]['temperature_2m'].append(self.forecast_data['hourly']['time'][i])

            if row[1] < self.low_thresholds['relativehumidity_2m']:
                alerts[day]['relativehumidity_2m'].append(self.forecast_data['hourly']['time'][i])

            if row[2] > self.high_thresholds['windspeed_10m']:
                alerts[day]['windspeed_10m'].append(self.forecast_data['hourly']['time'][i])

        for i in range(1, 8):
            current_day = self.int_to_week[(today + i - 2) % 7 + 1]
            for type in alerts[i]:
                res = {}
                if alerts[i][type]:
                    intervals = investigate_one_day(alerts[i][type])
                    if not intervals: continue
                    # TODO: hours integration
                    res['hours'] = intervals
                    res['type'] = 0
                    res['reason'] = alert_type[type]
                    self.notifications[current_day].append(res)

    def decrease_irrigation_alert(self, today=1):
        alerts = {}
        alert_type = {'precipitation': 'high precipitation', 'soil_moisture_9_27cm': 'high soil moisture'}
        day = 0
        for i, row in enumerate(zip(self.forecast_data['hourly']['precipitation'],
                                    self.forecast_data['hourly']['soil_moisture_9_27cm'])):
            if i % 24 == 0:
                day += 1
                alerts[day] = {}
                alerts[day]['precipitation'] = []
                alerts[day]['soil_moisture_9_27cm'] = []
            if row[0] > self.high_thresholds['precipitation']:
                alerts[day]['precipitation'].append(self.forecast_data['hourly']['time'][i])

            if row[1] > self.high_thresholds['soil_moisture_7_to_28cm']:
                alerts[day]['soil_moisture_9_27cm'].append(self.forecast_data['hourly']['time'][i])

        for i in range(1, 8):
            current_day = self.int_to_week[(today + i - 2) % 7 + 1]
            for type in alerts[i]:
                res = {}
                if alerts[i][type]:
                    intervals = investigate_one_day(alerts[i][type])
                    if not intervals: continue
                    res['hours'] = intervals
                    res['type'] = 0
                    res['reason'] = alert_type[type]
                    self.notifications[current_day].append(res)

    def handle(self, *args, **kwargs):
        Event.objects.all().delete()
        self.increase_irrigation_alert(today=self.week_to_int[self.TODAY])
        self.decrease_irrigation_alert(today=self.week_to_int[self.TODAY])
        self.frost_warning(today=self.week_to_int[self.TODAY])
        events = []
        for i in self.notifications:
            for j in self.notifications[i]:
                importance = random.randint(0, 2)
                if importance==0:
                    self.send_notification(j['reason'])
                events.append(Event(title=j['reason'], type=j['type'], date=i, importance=importance))
        Event.objects.bulk_create(events)

    def send_notification(self, body):
        registration_token = 'cksEuS-pRA6M6YIapATRT6:APA91bGdLb8rQ-wrDwLioQwzTiUafLtK46uTZ2WGNwAa2ZFFOzUxf7ILMW217Y9qP5ZNqY0qWdIxMNA_Ye6y1xAloacvbZ9WJpZ8-UYz_UCn13ciYmevIcGgfsdRpK-9uYitqblsE38d'
        title = 'Critical Event'
        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=body + ' is expected',
                image='https://img.icons8.com/plumpy/512/important-event.png',
            ),
            token=registration_token,
        )
        response = messaging.send(message)
        print('Successfully sent message:', message.notification)