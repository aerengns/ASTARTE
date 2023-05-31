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
            farm_sensors = []
            for reports in all_reports:
                if reports.latitude > max_latitude or reports.latitude < min_latitude or \
                reports.longitude > max_longitude or reports.longitude < min_longitude:
                    continue
                lon, lat = reports.longitude, reports.latitude
                lon = (lon - min_longitude)*111000
                lat = (lat - min_latitude)*111000
                farm_sensors.append([lon, lat, reports.moisture])
            sensors = np.array(farm_sensors)

            number_of_rows = 20
            rows, columns, zi, zi_heatmap = dynamic_heatmap(farm_corners.copy(), sensors.copy(), number_of_rows=number_of_rows)

            sensor_locations = find_rows_and_columns_of(farm_corners.copy(), sensors.copy(), number_of_rows=number_of_rows)

            img_buf = plot_heatmap(zi_heatmap, sensors.copy(), farm_corners.copy(), color='Blues')

            img_byte_arr = img_buf.getvalue()
            encoded_image = base64.b64encode(img_byte_arr).decode('utf-8')

            events = {'rows': np.flip(rows), 'columns': columns, 'items': np.nan_to_num(zi).flatten(), 'sensor_locations': sensor_locations, 'heatmap_image': encoded_image}

            return Response(data=events)
        
        elif heatmap_type == 'n':

            farm_sensors = []
            for reports in all_reports:
                if reports.latitude > max_latitude or reports.latitude < min_latitude or \
                reports.longitude > max_longitude or reports.longitude < min_longitude:
                    continue
                lon, lat = reports.longitude, reports.latitude
                lon = (lon - min_longitude)*111000
                lat = (lat - min_latitude)*111000
                farm_sensors.append([lon, lat, reports.nitrogen])
            sensors = np.array(farm_sensors)
            # mult_quofficient = 10/np.max(sensors[:,2])
            # sensors[:,2] = sensors[:,2]*mult_quofficient

            

            number_of_rows = 20
            rows, columns, zi, zi_heatmap = dynamic_heatmap(farm_corners.copy(), sensors.copy(), number_of_rows=number_of_rows)
            
            sensor_locations = find_rows_and_columns_of(farm_corners.copy(), sensors.copy(), number_of_rows=number_of_rows)

            img_buf = plot_heatmap(zi_heatmap, sensors.copy(), farm_corners.copy(), color='Greens')

            img_byte_arr = img_buf.getvalue()
            encoded_image = base64.b64encode(img_byte_arr).decode('utf-8')

            events = {'rows': np.flip(rows), 'columns': columns, 'items': np.nan_to_num(zi).flatten(), 'sensor_locations': sensor_locations, 'heatmap_image': encoded_image}

            return Response(data=events)
             
        elif heatmap_type == 'p':
            farm_sensors = []
            for reports in all_reports:
                if reports.latitude > max_latitude or reports.latitude < min_latitude or \
                reports.longitude > max_longitude or reports.longitude < min_longitude:
                    continue
                lon, lat = reports.longitude, reports.latitude
                lon = (lon - min_longitude)*111000
                lat = (lat - min_latitude)*111000
                farm_sensors.append([lon, lat, reports.phosphorus])
            sensors = np.array(farm_sensors)

            number_of_rows = 20
            rows, columns, zi, zi_heatmap = dynamic_heatmap(farm_corners.copy(), sensors.copy(), number_of_rows=number_of_rows)

            sensor_locations = find_rows_and_columns_of(farm_corners.copy(), sensors.copy(), number_of_rows=number_of_rows)

            img_buf = plot_heatmap(zi_heatmap, sensors.copy(), farm_corners.copy(), color='Reds')

            img_byte_arr = img_buf.getvalue()
            encoded_image = base64.b64encode(img_byte_arr).decode('utf-8')

            events = {'rows': np.flip(rows), 'columns': columns, 'items': np.nan_to_num(zi).flatten(), 'sensor_locations': sensor_locations, 'heatmap_image': encoded_image}

            return Response(data=events)
        
        elif heatmap_type == 'k':
            farm_sensors = []
            for reports in all_reports:
                if reports.latitude > max_latitude or reports.latitude < min_latitude or \
                reports.longitude > max_longitude or reports.longitude < min_longitude:
                    continue
                lon, lat = reports.longitude, reports.latitude
                lon = (lon - min_longitude)*111000
                lat = (lat - min_latitude)*111000
                farm_sensors.append([lon, lat, reports.potassium])

            sensors = np.array(farm_sensors)

            number_of_rows = 20
            rows, columns, zi, zi_heatmap = dynamic_heatmap(farm_corners.copy(), sensors.copy(), number_of_rows=number_of_rows)

            sensor_locations = find_rows_and_columns_of(farm_corners.copy(), sensors.copy(), number_of_rows=number_of_rows)

            img_buf = plot_heatmap(zi_heatmap, sensors.copy(), farm_corners.copy(), color='Oranges')

            img_byte_arr = img_buf.getvalue()
            encoded_image = base64.b64encode(img_byte_arr).decode('utf-8')

            events = {'rows': np.flip(rows), 'columns': columns, 'items': np.nan_to_num(zi).flatten(), 'sensor_locations': sensor_locations, 'heatmap_image': encoded_image}

            return Response(data=events)
        
        elif heatmap_type == 'temperature':
            farm_sensors = []
            for reports in all_reports:
                if reports.latitude > max_latitude or reports.latitude < min_latitude or \
                reports.longitude > max_longitude or reports.longitude < min_longitude:
                    continue
                lon, lat = reports.longitude, reports.latitude
                lon = (lon - min_longitude)*111000
                lat = (lat - min_latitude)*111000
                farm_sensors.append([lon, lat, reports.temperature])

            sensors = np.array(farm_sensors)

            number_of_rows = 20
            rows, columns, zi, zi_heatmap = dynamic_heatmap(farm_corners, sensors.copy(), number_of_rows=number_of_rows)

            sensor_locations = find_rows_and_columns_of(farm_corners, sensors.copy(), number_of_rows=number_of_rows)

            img_buf = plot_heatmap(zi_heatmap, sensors.copy(), farm_corners, color='YlOrRd')

            img_byte_arr = img_buf.getvalue()
            encoded_image = base64.b64encode(img_byte_arr).decode('utf-8')

            events = {'rows': np.flip(rows), 'columns': columns, 'items': np.nan_to_num(zi).flatten(), 'sensor_locations': sensor_locations, 'heatmap_image': encoded_image}

            return Response(data=events)
        
        elif heatmap_type == 'ph':
            farm_sensors = []
            for reports in all_reports:
                if reports.latitude > max_latitude or reports.latitude < min_latitude or \
                reports.longitude > max_longitude or reports.longitude < min_longitude:
                    continue
                lon, lat = reports.longitude, reports.latitude
                lon = (lon - min_longitude)*111000
                lat = (lat - min_latitude)*111000
                farm_sensors.append([lon, lat, reports.ph])

            sensors = np.array(farm_sensors)

            number_of_rows = 20
            rows, columns, zi, zi_heatmap = dynamic_heatmap(farm_corners.copy(), sensors.copy(), number_of_rows=number_of_rows)

            sensor_locations = find_rows_and_columns_of(farm_corners.copy(), sensors.copy(), number_of_rows=number_of_rows)

            img_buf = plot_heatmap(zi_heatmap, sensors.copy(), farm_corners.copy(), color='RdPu')

            img_byte_arr = img_buf.getvalue()
            encoded_image = base64.b64encode(img_byte_arr).decode('utf-8')

            events = {'rows': np.flip(rows), 'columns': columns, 'items': np.nan_to_num(zi).flatten(), 'sensor_locations': sensor_locations, 'heatmap_image': encoded_image}

            return Response(data=events)