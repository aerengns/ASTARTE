from datetime import datetime, timedelta

from django.http import HttpResponse
from firebase_admin import messaging
from rest_framework import status
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from calendarapp.models import Event, CustomEvent
from firebase_auth.authentication import FirebaseAuthentication
from backendcore.models import Farm


class CalendarDataAPI(APIView):
    permission_classes = [AllowAny]
    authentication_classes = [FirebaseAuthentication]

    def post(self, request, *args, **kwargs):
        farm_ids = request.POST.get('farm_ids')
        print(f'farm_ids: {farm_ids}')
        events = [{'title': event.title, 'event_type': event.type, 'date': event.date.strftime('%Y-%m-%d'),
                   'importance': event.importance} for event in
                  Event.objects.filter(date__gte=datetime.now() - timedelta(weeks=12), farm_id__in=farm_ids)]
        print(f'events:{events}')
        return Response(data={'events': events})


class CreateEventAPI(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request):
        date = request.data.get('date')
        date = datetime.strptime(date, '%Y-%m-%d')
        events = Event.objects.filter(date=date)
        return Response(data={'events': events.values()})

    def post(self, request):
        description = request.data.get('description')
        date = request.data.get('date')
        date = datetime.strptime(date, '%Y-%m-%d')
        CustomEvent.objects.create(description=description, date=date)
        return Response({'message': 'Event created'}, status=status.HTTP_201_CREATED)
