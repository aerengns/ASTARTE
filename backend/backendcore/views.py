import os

from django.core.files.base import ContentFile
from django.core.files.storage import default_storage
from django.views import View
from django.core.files import File  # you need this somewhere
import urllib

from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from rest_framework.views import APIView

from backendapp import settings


# Create your views here.

class HelloDjango(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        print('Request recevied')

        return Response('Hello from ASTARTE!')

    def post(self, request, *args, **kwargs):
        print('Request POST received')
        print(request.FILES)
        print(args)
        print(kwargs)
        data = request.FILES['yourPictureKey']  # or self.files['image'] in your form

        path = default_storage.save('tmp/somename.png', ContentFile(data.read()))
        tmp_file = os.path.join(settings.MEDIA_ROOT, path)

        return Response('Hello from ASTARTE!')