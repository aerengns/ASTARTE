import base64
import io
import json

from django.forms import model_to_dict
from django.http import JsonResponse, HttpResponse, HttpResponseBadRequest
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from accounts.models import Profile
from backendcore.models import Farm
from backendcore.utils.core_utils import send_notification
from calendarapp.models import Event
from firebase_auth.authentication import FirebaseAuthentication
from workers.models import Worker
from PIL import Image


class WorkerDataAPI(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def post(self, request, *args, **kwargs):
        print('Request POST received')
        current_worker = Worker.objects.get(profile__user=request.user)
        workers = Worker.objects.filter(profile__user_type=Profile.UserTypes.WORKER,
                                        permission_level__lte=current_worker.permission_level).exclude(
            id=current_worker.id)
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


# Gets jobs available and assigns them
class JobDataAPI(APIView):
    permission_classes = [AllowAny]
    authentication_classes = [FirebaseAuthentication]

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
            notification_msg = {
                'title': 'New Work',
                'body': 'New work assigned please check for yourself.',
            }
            send_notification(worker.profile, notification_msg)
        except Exception as e:
            print(e)
            return HttpResponseBadRequest("Failed!")
        return HttpResponse("Success!")


class JobFinishAPI(APIView):
    permission_classes = [AllowAny]
    authentication_classes = [FirebaseAuthentication]

    def post(self, request, *args, **kwargs):
        try:
            worker = request.user.profile.worker
            if not worker.event:
                return HttpResponse('Success!')
            assigner = worker.event.assigner
            if assigner:
                send_notification(assigner, {'title': 'Work Done',
                                             'body': f'Work with id: {worker.event_id} is completed successfully.'})
            else:
                # TODO: send notification to farm owner
                pass
            event = worker.event
            worker.event = None
            worker.save()
            event.delete()
            return HttpResponse('Success!')

        except Exception as e:
            print(e)
            return HttpResponseBadRequest("Failed!")


class WorkerRelatedFarmsAPI(APIView):
    permission_classes = [AllowAny]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request, *args, **kwargs):
        worker = request.user.profile.worker
        farm_ids = []
        if worker.event:
            farm_ids = [(worker.event.farm.id, worker.event.farm.name)]
        if request.user.profile.user_type == Profile.UserTypes.FARM_OWNER:
            farm_ids += list(Farm.objects.filter(owner=request.user).values_list('id', 'name'))
        return JsonResponse(farm_ids, safe=False)


