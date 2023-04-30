from django.shortcuts import render
import os

from django.core.files.base import ContentFile
from django.core.files.storage import default_storage
from django.views import View
from django.core.files import File  # you need this somewhere
import urllib

from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.views import APIView

from firebase_auth.authentication import FirebaseAuthentication


# Create your views here.
class HumidityReportAPI(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request):
        print('Report request recevied')

        return Response('Hello from ASTARTE!')

    def post(self, request, *args, **kwargs):
        print('Request POST received')

        days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']

        humidity_levels = [25, 24, 24, 45, 43, 42, 40]

        return Response(data={'days': days, 'humidity_levels': humidity_levels})


class NPKReportAPI(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request):
        print('Report request recevied')

        return Response('Hello from ASTARTE!')

    def post(self, request, *args, **kwargs):
        print('Request POST received')

        days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']

        n_values = [25, 24, 24, 45, 43, 42, 40]
        p_values = [12, 11, 11, 12, 20, 19, 19]
        k_values = [15, 10, 15, 16, 18, 18, 17]

        return Response(data={'days': days, 'n_values': n_values, 'p_values': p_values, 'k_values': k_values})


class TemperatureReportAPI(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request):
        print('Report request recevied')

        return Response('Hello from ASTARTE!')

    def post(self, request, *args, **kwargs):
        print('Request POST received')

        days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']

        temperatures = [25, 24, 24, 45, 43, 42, 40]

        return Response(data={'days': days, 'temperatures': temperatures})
