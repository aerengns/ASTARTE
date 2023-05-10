import base64

from django.shortcuts import render
import os

from django.core.files.base import ContentFile
from django.core.files.storage import default_storage
from django.views import View
from django.core.files import File  # you need this somewhere
import urllib

from rest_framework import status
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.views import APIView

from firebase_auth.authentication import FirebaseAuthentication
from posts.models import Post
from posts.serializers import PostSerializer


class PostList(APIView):
    permission_classes = [AllowAny]
    # authentication_classes = [FirebaseAuthentication]

    def get(self, request):
        posts = Post.objects.all()
        return Response(posts.values())


class PostCreate(APIView):
    permission_classes = [AllowAny]
    # authentication_classes = [FirebaseAuthentication]

    def post(self, request):
        message = request.data.get('message')
        image = request.data.get('image')

        if not message:
            return Response({'message': 'Please provide a message'}, status=status.HTTP_400_BAD_REQUEST)

        post = Post.objects.create(message=message, image=image)
        serializer = PostSerializer(post)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
