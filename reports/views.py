from django.shortcuts import render
import os

from django.core.files.base import ContentFile
from django.core.files.storage import default_storage
from django.views import View
from django.core.files import File  # you need this somewhere
import urllib

from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from rest_framework.views import APIView


# Create your views here.
class HumidityReportAPI(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        print('Report request recevied')

        return Response('Hello from ASTARTE!')

    def post(self, request, *args, **kwargs):
        print('Request POST received')

        days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']

        humidity_levels = [25, 24, 24, 45, 43, 42, 40]

        return Response(data={'days': days, 'humidity_levels': humidity_levels})

