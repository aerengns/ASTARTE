from django.core.management.base import BaseCommand
from backendcore.models import FarmReport, Farm, FarmCornerPoint

# UPDATE FARM WITH ID 3 THAT HAVE 5 CORNER POINTS AND 4 SENSOR REPORTS
class Command(BaseCommand):
    def handle(self, *args, **kwargs):
        farm_id = 3
        farm3_corners = FarmCornerPoint.objects.filter(farm_id=farm_id)
        farm_corners = [[29.9999,39.9999],[30.009,40.0073], [30.0072,40.00018], 
                        [30.0049,40.009], [29.99, 40.015]]
        
        for i, farm in enumerate(farm3_corners):
            farm.latitude = farm_corners[i][1]
            farm.longitude = farm_corners[i][0]
            farm.save()

        sensor3_reports = FarmReport.objects.filter(farm_id=farm_id)
        sensor_locations = [[30.001, 40.001], [29.99, 40.005], 
                            [30.003, 40.005], [30.005, 40.007]]
        
        for i, sensor in enumerate(sensor3_reports):
            sensor.latitude = sensor_locations[i][1]
            sensor.longitude = sensor_locations[i][0]
            sensor.save()