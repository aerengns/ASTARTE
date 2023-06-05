from django.core.management.base import BaseCommand
from backendcore.models import FarmReport, Farm, FarmCornerPoint
from random import random

from reports.models import FarmReportLog


# UPDATE FARM WITH ID 3 THAT HAVE 5 CORNER POINTS AND 4 SENSOR REPORTS
class Command(BaseCommand):

    def save_model(self, objects, sensor_locations, sensor_values):
        for i, sensor in enumerate(objects):
            sensor.latitude = sensor_locations[i][1]
            sensor.longitude = sensor_locations[i][0]
            sensor.moisture = sensor_values[i]['moisture']
            sensor.phosphorus = sensor_values[i]['p']
            sensor.nitrogen = sensor_values[i]['n']
            sensor.potassium = sensor_values[i]['k']
            sensor.temperature = sensor_values[i]['temp']
            sensor.ph = sensor_values[i]['ph']
            sensor.save()

    def handle(self, *args, **kwargs):
        farm_id = 6
        farm3_corners = FarmCornerPoint.objects.filter(farm_id=farm_id)
        farm_corners = [[29.9999,39.9999],[30.009,40.0073], [30.0072,40.00018], 
                        [30.0049,40.009], [29.99, 40.015]]
        
        for i, farm in enumerate(farm3_corners):
            farm.latitude = farm_corners[i][1]
            farm.longitude = farm_corners[i][0]
            farm.save()

        sensor3_reports = FarmReport.objects.filter(farm_id=farm_id)
        sensor3_report_logs = FarmReportLog.objects.filter(farm_id=farm_id)
        sensor_locations = [[30.001, 40.001], [29.99, 40.005], 
                            [30.003, 40.005], [30.005, 40.007],
                            [30.0075, 40.0015], [29.993,40.0085]]

        sensor_values = [{'moisture': 50+50*random(), 'p': 2000*random(), 'k': 2000*random(), 'n': 2000*random(), 'temp': 20+10*random(), 'ph': 5+3*random()}, 
                         {'moisture': 50+50*random(), 'p': 2000*random(), 'k': 2000*random(), 'n': 2000*random(), 'temp': 20+10*random(), 'ph': 5+3*random()},
                         {'moisture': 50+50*random(), 'p': 2000*random(), 'k': 2000*random(), 'n': 2000*random(), 'temp': 20+10*random(), 'ph': 5+3*random()},
                         {'moisture': 50+50*random(), 'p': 2000*random(), 'k': 2000*random(), 'n': 2000*random(), 'temp': 20+10*random(), 'ph': 5+3*random()},
                         {'moisture': 50+50*random(), 'p': 2000*random(), 'k': 2000*random(), 'n': 2000*random(), 'temp': 20+10*random(), 'ph': 5+3*random()},
                         {'moisture': 50+50*random(), 'p': 2000*random(), 'k': 2000*random(), 'n': 2000*random(), 'temp': 20+10*random(), 'ph': 5+3*random()},]

        self.save_model(sensor3_reports, sensor_locations, sensor_values)
        self.save_model(sensor3_report_logs, sensor_locations, sensor_values)
