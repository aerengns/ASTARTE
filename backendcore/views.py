import base64

from django.http import Http404

from rest_framework import status
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from rest_framework.views import APIView

from backendcore.models import FarmReport, Farm
from backendcore.serializers import FarmSerializer, FarmReportSerializer

from rest_framework.permissions import IsAuthenticated

from firebase_auth.authentication import FirebaseAuthentication

from dynamic_heatmap import dynamic_heatmap, find_rows_and_columns_of, plot_heatmap
import numpy as np
from random import random


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
    permission_classes = [AllowAny]
    authentication_classes = []

    def get(self, request, heatmap_type):
        print('Request recevied')
        

        if heatmap_type == 'moisture':
            farm_corners = [[300,500],[600,400], [600,0], [0,100], [0,300], [300,0]]
            farm_corners = [[20,30],[1000,800], [850,20], [100,800], [500,1000]]
            sensors = np.zeros((10, 3))  # w, h, value
            for i in range(10):
                x,y,v = 100+800*random(), 100+800*random(), 100*random()
                curr = np.array([x,y,v])
                sensors[i] = curr
            # sensors = np.array([[522.65376412, 427.41600244,  13.06000998],
            #                     [396.81318874, 591.42826318,  53.65369118],
            #                     [449.85461397, 382.34698418,  25.07147272],
            #                     [661.00950662, 654.96374368,  29.64015572],
            #                     [321.92585641, 608.52216015,  79.14850035],
            #                     [453.93996295, 532.63975706,  43.65067217],
            #                     [429.57552743, 554.50984214,  63.41508049],
            #                     [639.03549159, 382.75902613,  23.78781876],
            #                     [603.28219428, 676.45087338,  31.60635241],
            #                     [307.13265298, 443.10370478,  97.088938  ]])
            sensors[:,2] /= 11

            number_of_rows = 20
            rows, columns, zi, zi_heatmap = dynamic_heatmap(farm_corners, sensors.copy(), number_of_rows=number_of_rows)

            sensor_locations = find_rows_and_columns_of(farm_corners, sensors, number_of_rows=number_of_rows)

            img_buf = plot_heatmap(zi_heatmap, sensors, farm_corners, color='Blues')

            img_byte_arr = img_buf.getvalue()
            encoded_image = base64.b64encode(img_byte_arr).decode('utf-8')

            events = {'rows': rows, 'columns': columns, 'items': np.nan_to_num(zi).flatten(), 'sensor_locations': sensor_locations, 'heatmap_image': encoded_image}

            return Response(data=events)
        
        elif heatmap_type == 'n':
            farm_corners = [[300,500],[600,400], [600,0], [0,100], [0,300], [300,0]]
            sensors = np.zeros((10, 3))  # w, h, value
            sensors = np.array([[522.65376412, 427.41600244,  13.06000998],
                                [396.81318874, 591.42826318,  53.65369118],
                                [449.85461397, 382.34698418,  25.07147272],
                                [661.00950662, 654.96374368,  29.64015572],
                                [321.92585641, 608.52216015,  79.14850035],
                                [453.93996295, 532.63975706,  43.65067217],
                                [429.57552743, 554.50984214,  63.41508049],
                                [639.03549159, 382.75902613,  23.78781876],
                                [603.28219428, 676.45087338,  31.60635241],
                                [307.13265298, 443.10370478,  97.088938  ]])
            sensors[:,2] /= 11

            number_of_rows = 20
            rows, columns, zi, zi_heatmap = dynamic_heatmap(farm_corners, sensors.copy(), number_of_rows=number_of_rows)

            sensor_locations = find_rows_and_columns_of(farm_corners, sensors, number_of_rows=number_of_rows)

            img_buf = plot_heatmap(zi_heatmap, sensors, farm_corners, color='Greens')

            img_byte_arr = img_buf.getvalue()
            encoded_image = base64.b64encode(img_byte_arr).decode('utf-8')

            events = {'rows': rows, 'columns': columns, 'items': np.nan_to_num(zi).flatten(), 'sensor_locations': sensor_locations, 'heatmap_image': encoded_image}

            return Response(data=events)   
             
        elif heatmap_type == 'p':
            farm_corners = [[1000,1000],[1000,0], [0,1000], [0,500], [0,0]]
            sensors = np.zeros((20, 3))  # w, h, value
            for i in range(20):
                x,y,v = 100+800*random(), 100+800*random(), 100*random()
                curr = np.array([x,y,v])
                sensors[i] = curr
            sensors[:,2] /= 11

            number_of_rows = 20
            rows, columns, zi, zi_heatmap = dynamic_heatmap(farm_corners, sensors.copy(), number_of_rows=number_of_rows)

            sensor_locations = find_rows_and_columns_of(farm_corners, sensors, number_of_rows=number_of_rows)

            img_buf = plot_heatmap(zi_heatmap, sensors, farm_corners, color='Reds')

            img_byte_arr = img_buf.getvalue()
            encoded_image = base64.b64encode(img_byte_arr).decode('utf-8')

            events = {'rows': rows, 'columns': columns, 'items': np.nan_to_num(zi).flatten(), 'sensor_locations': sensor_locations, 'heatmap_image': encoded_image}

            return Response(data=events)
        
        elif heatmap_type == 'k':
            farm_corners = [[800,800],[800,0], [0,800], [400,500], [200,200]]
            sensors = np.zeros((5, 3))  # w, h, value
            for i in range(5):
                x,y,v = 100+600*random(), 100+600*random(), 100*random()
                curr = np.array([x,y,v])
                sensors[i] = curr
            sensors[:,2] /= 11

            number_of_rows = 20
            rows, columns, zi, zi_heatmap = dynamic_heatmap(farm_corners, sensors.copy(), number_of_rows=number_of_rows)

            sensor_locations = find_rows_and_columns_of(farm_corners, sensors, number_of_rows=number_of_rows)

            img_buf = plot_heatmap(zi_heatmap, sensors, farm_corners, color='Oranges')

            img_byte_arr = img_buf.getvalue()
            encoded_image = base64.b64encode(img_byte_arr).decode('utf-8')

            events = {'rows': rows, 'columns': columns, 'items': np.nan_to_num(zi).flatten(), 'sensor_locations': sensor_locations, 'heatmap_image': encoded_image}

            return Response(data=events)
        
        elif heatmap_type == 'temperature':
            farm_corners = [[800,800],[800,0], [0,800], [400,500], [200,200]]
            sensors = np.zeros((5, 3))  # w, h, value
            for i in range(5):
                x,y,v = 100+600*random(), 100+600*random(), 100*random()
                curr = np.array([x,y,v])
                sensors[i] = curr
            sensors[:,2] /= 11

            number_of_rows = 20
            rows, columns, zi, zi_heatmap = dynamic_heatmap(farm_corners, sensors.copy(), number_of_rows=number_of_rows)

            sensor_locations = find_rows_and_columns_of(farm_corners, sensors, number_of_rows=number_of_rows)

            img_buf = plot_heatmap(zi_heatmap, sensors, farm_corners, color='YlOrRd')

            img_byte_arr = img_buf.getvalue()
            encoded_image = base64.b64encode(img_byte_arr).decode('utf-8')

            events = {'rows': rows, 'columns': columns, 'items': np.nan_to_num(zi).flatten(), 'sensor_locations': sensor_locations, 'heatmap_image': encoded_image}

            return Response(data=events)
        
        elif heatmap_type == 'ph':
            farm_corners = [[800,800],[800,0], [0,800], [400,500], [200,200]]
            sensors = np.zeros((5, 3))  # w, h, value
            for i in range(5):
                x,y,v = 100+600*random(), 100+600*random(), 100*random()
                curr = np.array([x,y,v])
                sensors[i] = curr
            sensors[:,2] /= 11

            number_of_rows = 20
            rows, columns, zi, zi_heatmap = dynamic_heatmap(farm_corners, sensors.copy(), number_of_rows=number_of_rows)

            sensor_locations = find_rows_and_columns_of(farm_corners, sensors, number_of_rows=number_of_rows)

            img_buf = plot_heatmap(zi_heatmap, sensors, farm_corners, color='RdPu')

            img_byte_arr = img_buf.getvalue()
            encoded_image = base64.b64encode(img_byte_arr).decode('utf-8')

            events = {'rows': rows, 'columns': columns, 'items': np.nan_to_num(zi).flatten(), 'sensor_locations': sensor_locations, 'heatmap_image': encoded_image}

            return Response(data=events)