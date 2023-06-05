import json
from datetime import datetime, timedelta

from django.http import HttpResponse, HttpResponseBadRequest
from firebase_admin import messaging
from rest_framework import status
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from calendarapp.models import Event
from firebase_auth.authentication import FirebaseAuthentication
from backendcore.models import Farm


class CalendarDataAPI(APIView):
    permission_classes = [AllowAny]
    authentication_classes = [FirebaseAuthentication]

    def post(self, request, *args, **kwargs):
        farm_ids = json.loads(request.POST.get('farm_ids'))
        events = [
            {'id': event.id, 'title': event.title, 'event_type': event.type, 'date': event.date.strftime('%Y-%m-%d'),
             'importance': event.importance, 'description': event.description} for event in
            Event.objects.filter(date__gte=datetime.now() - timedelta(weeks=12), farm_id__in=farm_ids)]
        return Response(data={'events': events})


class CreateEventAPI(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def post(self, request):
        event_dict = json.loads(request.data['event'])
        event_dict.pop('id', None)
        event_dict['assigner'] = request.user.profile
        date_string = event_dict['date'].split('T')[0]
        event_dict['date'] = datetime.strptime(date_string, '%Y-%m-%d')
        event_dict['farm_id'] = int(request.data.get('farm_id'))
        if event_dict['description'] == '':
            event_dict['description'] = None
        event = Event(**event_dict)
        event.save()
        return Response({'message': 'Event created'}, status=status.HTTP_201_CREATED)


class EditEventAPI(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get_event(self, request):
        event_dict = json.loads(request.data['event'])
        try:
            return Event.objects.get(id=event_dict['id'])
        except Event.DoesNotExist:
            return None

    def delete(self, request):
        event_instance = self.get_event(request)
        if not event_instance:
            return HttpResponseBadRequest("Failed!")
        event_instance.delete()
        return HttpResponse('Success', status=status.HTTP_204_NO_CONTENT)

    def post(self, request):
        event_instance = self.get_event(request)
        if not event_instance:
            return HttpResponseBadRequest("Failed!")
        event_instance.title = request.data.get('title')
        event_instance.description = request.data.get('description')
        event_instance.type = int(request.data.get('type'))
        event_instance.importance = int(request.data.get('importance'))
        event_instance.save()

        return Response({'message': 'Event edited'}, status=status.HTTP_200_OK)
