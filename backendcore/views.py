import base64

from django.http import Http404

from rest_framework import status
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from rest_framework.views import APIView

from backendcore.models import FarmReport, Farm, FarmCornerPoint
from backendcore.serializers import FarmSerializer, FarmReportSerializer, CreateFarmSerializer

from rest_framework.permissions import IsAuthenticated

from firebase_auth.authentication import FirebaseAuthentication


import numpy as np
from random import random
from time import sleep

from scripts.dynamic_heatmap import dynamic_heatmap, plot_heatmap, find_rows_and_columns_of


class ReportDetail(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get_object(self, report_id):
        try:
            return FarmReport.objects.get(id=report_id)
        except FarmReport.DoesNotExist:
            raise Http404

    def get(self, request, report_id):
        report = self.get_object(report_id)
        serializer = FarmReportSerializer(report)
        return Response(serializer.data)

    def put(self, request, report_id):
        report = self.get_object(report_id)
        serializer = FarmReportSerializer(report, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, report_id):
        report = self.get_object(report_id)
        report.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class ReportList(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request, farm_id):
        reports = FarmReport.objects.filter(farm_id=farm_id)
        serializer = FarmReportSerializer(reports, many=True)
        return Response(serializer.data)

    def post(self, request, farm_id):
        serializer = FarmReportSerializer(data=request.data)
        farm = Farm.objects.get(id=farm_id)
        if serializer.is_valid():
            report = serializer.save()
            report.farm = farm
            report.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class FarmDetail(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get_object(self, farm_id):
        try:
            return Farm.objects.get(id=farm_id)
        except Farm.DoesNotExist:
            raise Http404

    def get(self, request, farm_id):
        farm = self.get_object(farm_id)
        serializer = FarmSerializer(farm)
        return Response(serializer.data)

    def put(self, request, farm_id):
        farm = self.get_object(farm_id)
        serializer = FarmSerializer(farm, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, farm_id):
        farm = self.get_object(farm_id)
        farm.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class FarmList(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request):
        reports = Farm.objects.filter(owner=request.user)
        serializer = FarmSerializer(reports, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = CreateFarmSerializer(data=request.data, context={'user_id': request.user.id})
        if serializer.is_valid():
            farm = serializer.save()
            farm.owner = request.user
            farm.save()
            return Response({"status": "success", "farm_id": farm.id}, status=status.HTTP_200_OK)
        else:
            return Response({"status": "error", "data": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


class GetTokenCredentials(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request):
        content = {
            'user': str(request.user),  # `django.contrib.authentication.User` instance.
            'authentication': str(request.auth),  # None
        }
        return Response(content)

class GetDynamicHeatmap(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request, farm_id, heatmap_type):
        print('Request recevied')


        # farm_corners = np.array([[29.9999,39.9999],[30.009,40.0073], [30.0072,40.00018], [30.0049,40.009]])
        # farm_corners = np.array([ [30.008,40],[30.01,39.991], [30,40], [30,39.991]])

        farm_corners = []
        farm_corners_point = FarmCornerPoint.objects.filter(farm_id = farm_id)
        for corner_point in farm_corners_point:
            farm_corners.append([corner_point.longitude, corner_point.latitude])

        farm_corners = np.array(farm_corners)

        min_longitude, min_latitude = np.min(farm_corners[:,0]), np.min(farm_corners[:,1])
        max_longitude, max_latitude = np.max(farm_corners[:,0]), np.max(farm_corners[:,1])
        farm_corners = farm_corners - np.array([min_longitude, min_latitude])
        farm_corners = farm_corners*111000 # 111km
        farm_corners = farm_corners.astype(int)
        

        farm_report = FarmReport.objects.filter(farm_id = farm_id).latest('date_collected')
        date = farm_report.date_collected
        all_reports = FarmReport.objects.filter(farm_id = farm_id, date_collected__year = date.year, 
                                        date_collected__month = date.month, date_collected__day = date.day)

        if heatmap_type == 'moisture':
            sleep(.1)
            farm_sensorsmoist = []
            for reports in all_reports:
                if reports.latitude > max_latitude or reports.latitude < min_latitude or \
                reports.longitude > max_longitude or reports.longitude < min_longitude:
                    continue
                lon, lat = reports.longitude, reports.latitude
                lon = (lon - min_longitude)*111000
                lat = (lat - min_latitude)*111000
                farm_sensorsmoist.append([lon, lat, reports.moisture])
            sensorsmoist = np.array(farm_sensorsmoist)

            # MAKE SENSOR VALUES BETWEEN 0-10
            sensorsmoist[:,2] /= 10
            number_of_rows = 20
            rows, columns, zimoist, zi_heatmapmoist = dynamic_heatmap(farm_corners.copy(), sensorsmoist.copy(), number_of_rows=number_of_rows)

            sensor_locations = find_rows_and_columns_of(farm_corners.copy(), sensorsmoist.copy(), number_of_rows=number_of_rows)
            img_bufmoist = plot_heatmap(zi_heatmapmoist, sensorsmoist.copy(), farm_corners.copy(), color='Blues', heatmap_type=heatmap_type)

            img_byte_arrmoist = img_bufmoist.getvalue()
            encoded_imagemoist = base64.b64encode(img_byte_arrmoist).decode('utf-8')

            eventsmoist = {'rows': np.flip(rows), 'columns': columns, 'items': np.nan_to_num(zimoist.T).flatten(), 'sensor_locations': sensor_locations, 'heatmap_image': encoded_imagemoist}

            return Response(data=eventsmoist)
        
        elif heatmap_type == 'n':
            sleep(.2)

            farm_sensorsn = []
            for reports in all_reports:
                if reports.latitude > max_latitude or reports.latitude < min_latitude or \
                reports.longitude > max_longitude or reports.longitude < min_longitude:
                    continue
                lon, lat = reports.longitude, reports.latitude
                lon = (lon - min_longitude)*111000
                lat = (lat - min_latitude)*111000
                farm_sensorsn.append([lon, lat, reports.nitrogen])
            sensorsn = np.array(farm_sensorsn)
            
            # MAKE SENSOR VALUES BETWEEN 0-10
            sensorsn[:,2] /= 200

            number_of_rows = 20
            rows, columns, zin, zi_heatmapn = dynamic_heatmap(farm_corners.copy(), sensorsn.copy(), number_of_rows=number_of_rows)
            
            sensor_locations = find_rows_and_columns_of(farm_corners.copy(), sensorsn.copy(), number_of_rows=number_of_rows)

            img_bufn = plot_heatmap(zi_heatmapn, sensorsn.copy(), farm_corners.copy(), color='Greens', heatmap_type=heatmap_type)

            img_byte_arrn = img_bufn.getvalue()
            encoded_imagen = base64.b64encode(img_byte_arrn).decode('utf-8')

            eventsn = {'rows': np.flip(rows), 'columns': columns, 'items': np.nan_to_num(zin.T).flatten(), 'sensor_locations': sensor_locations, 'heatmap_image': encoded_imagen}

            return Response(data=eventsn)
             
        elif heatmap_type == 'p':
            sleep(.3)
            farm_sensorsp = []
            for reports in all_reports:
                if reports.latitude > max_latitude or reports.latitude < min_latitude or \
                reports.longitude > max_longitude or reports.longitude < min_longitude:
                    continue
                lon, lat = reports.longitude, reports.latitude
                lon = (lon - min_longitude)*111000
                lat = (lat - min_latitude)*111000
                farm_sensorsp.append([lon, lat, reports.phosphorus])
            sensorsp = np.array(farm_sensorsp)

            # MAKE SENSOR VALUES BETWEEN 0-10
            sensorsp[:,2] /= 200

            number_of_rows = 20
            rows, columns, zip, zi_heatmapp = dynamic_heatmap(farm_corners.copy(), sensorsp.copy(), number_of_rows=number_of_rows)

            sensor_locations = find_rows_and_columns_of(farm_corners.copy(), sensorsp.copy(), number_of_rows=number_of_rows)

            img_bufp = plot_heatmap(zi_heatmapp, sensorsp.copy(), farm_corners.copy(), color='Reds', heatmap_type=heatmap_type)

            img_byte_arrp = img_bufp.getvalue()
            encoded_imagep = base64.b64encode(img_byte_arrp).decode('utf-8')

            eventsp = {'rows': np.flip(rows), 'columns': columns, 'items': np.nan_to_num(zip.T).flatten(), 'sensor_locations': sensor_locations, 'heatmap_image': encoded_imagep}

            return Response(data=eventsp)
        
        elif heatmap_type == 'k':
            sleep(.4)
            farm_sensorsk = []
            for reports in all_reports:
                if reports.latitude > max_latitude or reports.latitude < min_latitude or \
                reports.longitude > max_longitude or reports.longitude < min_longitude:
                    continue
                lon, lat = reports.longitude, reports.latitude
                lon = (lon - min_longitude)*111000
                lat = (lat - min_latitude)*111000
                farm_sensorsk.append([lon, lat, reports.potassium])

            sensorsk = np.array(farm_sensorsk)

            # MAKE SENSOR VALUES BETWEEN 0-10
            sensorsk[:,2] /= 200

            number_of_rows = 20
            rows, columns, zik, zi_heatmapk = dynamic_heatmap(farm_corners.copy(), sensorsk.copy(), number_of_rows=number_of_rows)

            sensor_locations = find_rows_and_columns_of(farm_corners.copy(), sensorsk.copy(), number_of_rows=number_of_rows)

            img_bufk = plot_heatmap(zi_heatmapk, sensorsk.copy(), farm_corners.copy(), color='Oranges', heatmap_type=heatmap_type)

            img_byte_arrk = img_bufk.getvalue()
            encoded_imagek = base64.b64encode(img_byte_arrk).decode('utf-8')

            eventsk = {'rows': np.flip(rows), 'columns': columns, 'items': np.nan_to_num(zik.T).flatten(), 'sensor_locations': sensor_locations, 'heatmap_image': encoded_imagek}

            return Response(data=eventsk)
        
        elif heatmap_type == 'temperature':
            sleep(.5)
            farm_sensorstemp = []
            for reports in all_reports:
                if reports.latitude > max_latitude or reports.latitude < min_latitude or \
                reports.longitude > max_longitude or reports.longitude < min_longitude:
                    continue
                lon, lat = reports.longitude, reports.latitude
                lon = (lon - min_longitude)*111000
                lat = (lat - min_latitude)*111000
                farm_sensorstemp.append([lon, lat, reports.temperature])
            sensorstemp = np.array(farm_sensorstemp)

            # MAKE SENSOR VALUES BETWEEN 0-10
            sensorstemp[:,2] = (sensorstemp[:,2]+40)/12

            number_of_rows = 20
            rows, columns, zitemp, zi_heatmaptemp = dynamic_heatmap(farm_corners, sensorstemp.copy(), number_of_rows=number_of_rows)

            sensor_locations = find_rows_and_columns_of(farm_corners, sensorstemp.copy(), number_of_rows=number_of_rows)

            img_buftemp = plot_heatmap(zi_heatmaptemp, sensorstemp.copy(), farm_corners, color='YlOrRd', heatmap_type=heatmap_type)

            img_byte_arrtemp = img_buftemp.getvalue()
            encoded_imagetemp = base64.b64encode(img_byte_arrtemp).decode('utf-8')

            eventstemp = {'rows': np.flip(rows), 'columns': columns, 'items': np.nan_to_num(zitemp.T).flatten(), 'sensor_locations': sensor_locations, 'heatmap_image': encoded_imagetemp}

            return Response(data=eventstemp)
        
        elif heatmap_type == 'ph':
            sleep(.6)
            farm_sensorsph = []
            for reports in all_reports:
                if reports.latitude > max_latitude or reports.latitude < min_latitude or \
                reports.longitude > max_longitude or reports.longitude < min_longitude:
                    continue
                lon, lat = reports.longitude, reports.latitude
                lon = (lon - min_longitude)*111000
                lat = (lat - min_latitude)*111000
                farm_sensorsph.append([lon, lat, reports.ph])
            sensorsph = np.array(farm_sensorsph)
            
            # MAKE SENSOR VALUES BETWEEN 0-10
            sensorsph[:,2] = (sensorsph[:,2]-3)/(0.6)

            number_of_rows = 20
            rows, columns, ziph, zi_heatmapph = dynamic_heatmap(farm_corners.copy(), sensorsph.copy(), number_of_rows=number_of_rows)

            sensor_locations = find_rows_and_columns_of(farm_corners.copy(), sensorsph.copy(), number_of_rows=number_of_rows)

            img_bufph = plot_heatmap(zi_heatmapph, sensorsph.copy(), farm_corners.copy(), color='Blues', heatmap_type=heatmap_type)

            img_byte_arrph = img_bufph.getvalue()
            encoded_imageph = base64.b64encode(img_byte_arrph).decode('utf-8')

            eventsph = {'rows': np.flip(rows), 'columns': columns, 'items': np.nan_to_num(ziph.T).flatten(), 'sensor_locations': sensor_locations, 'heatmap_image': encoded_imageph}

            return Response(data=eventsph)