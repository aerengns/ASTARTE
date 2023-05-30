from django.http import HttpResponse
from django.shortcuts import render
from firebase_admin import messaging
from rest_framework.permissions import AllowAny
from rest_framework.views import APIView

from . import models

# Create your views here.

class SendTokenAPI(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        if request.method == 'POST':
            self.token = request.POST.get('token')
            user_type = request.POST.get('user_type')
            if models.DeviceToken.objects.filter(token=self.token).exists():
                return HttpResponse('Token already exists!')
            device_token = models.DeviceToken.objects.create(token=self.token, user_type=user_type)
            return HttpResponse('Token received!')
        else:
            return HttpResponse('Invalid request method!')

    def send_notification(self):
        registration_token = self.token
        title = 'Test Notification'
        body = 'This is a test notification from Django!'
        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=body,
            ),
            token=registration_token,
        )
        response = messaging.send(message)
        print('Successfully sent message:', response)
