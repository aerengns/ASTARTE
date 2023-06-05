import json

from django.http import HttpResponse
from django.shortcuts import render
from django.utils import timezone
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
            device_token = request.POST.get('device_token')
            user_dict = request.POST.get('user')
            user_dict = json.loads(user_dict)
            user = Profile.objects.get(name=user_dict['name'], surname=user_dict['surname'], email=user_dict['email'])
            device_token, created = DeviceToken.objects.get_or_create(token=device_token, user=user)
            if not created:
                device_token.date = timezone.now()
                device_token.save()
                return HttpResponse('Token already exists!')
            return HttpResponse('Token received!')
        else:
            return HttpResponse('Invalid request method!')
