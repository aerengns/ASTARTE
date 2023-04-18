import base64

from django.forms import model_to_dict
from django.http import JsonResponse
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from workers.models import Worker
from PIL import Image


class WorkerDataAPI(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        print('Request recevied')

        return Response('Hello from ASTARTE!')

    def post(self, request, *args, **kwargs):
        print('Request POST received')

        workers = Worker.objects.all()
        data = []
        for worker in workers:
            try:
                event_dic = model_to_dict(worker.event)

            except:
                event_dic = None
            image = Image.open(worker.profile_photo)
            # TODO: Fix image encode
            encoded_image = base64.b64encode(image.tobytes()).decode('utf-8')

            worker_dict = model_to_dict(worker)
            worker_dict['event'] = event_dic
            worker_dict['profile_photo'] = encoded_image
            data.append(worker_dict)
        return JsonResponse(data, safe=False)
