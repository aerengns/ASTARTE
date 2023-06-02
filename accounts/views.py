import json

from django.http import HttpResponse
from django.shortcuts import render
from firebase_admin import messaging
from rest_framework.permissions import AllowAny
from rest_framework.views import APIView

from firebase_auth.authentication import FirebaseAuthentication
from accounts.models import DeviceToken, Profile


class SendTokenAPI(APIView):
    permission_classes = [AllowAny]
    authentication_classes = [FirebaseAuthentication]

    def post(self, request):
        if request.method == 'POST':
            self.device_token = request.POST.get('device_token')
            user_dict = request.POST.get('user')
            user_dict = json.loads(user_dict)
            user = Profile.objects.get(name=user_dict['name'], surname=user_dict['surname'], email=user_dict['email'])
            _, created = DeviceToken.objects.get_or_create(token=self.device_token, user=user)
            if not created:
                return HttpResponse('Token already exists!')
            return HttpResponse('Token received!')
        else:
            return HttpResponse('Invalid request method!')

    def send_notification(self):
        registration_token = self.device_token
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
