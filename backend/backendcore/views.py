from django.views import View

from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from rest_framework.views import APIView
# Create your views here.

class HelloDjango(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        print('Request recevied')
        return Response('Hello from ASTARTE!')