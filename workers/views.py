import base64
import io
import json

from django.forms import model_to_dict
from django.http import JsonResponse, HttpResponse, HttpResponseBadRequest
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from accounts.models import Profile
from calendarapp.models import Event
from firebase_auth.authentication import FirebaseAuthentication
from workers.models import Worker
from PIL import Image


class WorkerDataAPI(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def post(self, request, *args, **kwargs):

        workers = Worker.objects.filter(profile__user_type=Profile.UserTypes.WORKER)
        data = []
        for worker in workers:
            try:
                event_dic = model_to_dict(worker.event)

            except:
                event_dic = None
            image = Image.open(worker.profile_photo)
            img_byte_arr = io.BytesIO()
            image.save(img_byte_arr, format='PNG')
            img_byte_arr = img_byte_arr.getvalue()
            encoded_image = base64.b64encode(img_byte_arr).decode('utf-8')

            worker_dict = model_to_dict(worker)
            worker_dict['event'] = event_dic
            worker_dict['profile_photo'] = encoded_image
            data.append(worker_dict)
        return JsonResponse(data, safe=False)


class JobDataAPI(APIView):
    permission_classes = [AllowAny]
    authentication_classes = []

    def get(self, request):
        taken_event_ids = Worker.objects.filter(event__isnull=False).values_list('event_id', flat=True)
        return Response([model_to_dict(event) for event in Event.objects.all().exclude(id__in=taken_event_ids)])

    def post(self, request, *args, **kwargs):
        worker = json.loads(request.data['worker'])
        event = json.loads(request.data['event'])
        try:
            worker = Worker.objects.get(name=worker['name'], surname=worker['surname'], email=worker['email'])
            event = Event.objects.get(**event)
            worker.event = event
            worker.save()
        except Exception as e:
            print(e)
            return HttpResponseBadRequest("Failed!")
        return HttpResponse("Success!")
