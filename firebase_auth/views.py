from django.shortcuts import render
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.permissions import AllowAny

# Create your views here.
from rest_framework.views import APIView
from rest_framework.response import Response

from firebase_auth.authentication import FirebaseAuthentication


class SampleView(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request):
        print(request.user)
        return Response({"message": "Hello, you are authenticated!"})