from datetime import datetime, timedelta

from django.http import HttpResponse
from firebase_admin import messaging
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from calendarapp.models import Event


class CalendarDataAPI(APIView):
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):

        events = [{'title': event.title, 'event_type': event.type, 'date': event.date.strftime('%Y-%m-%d'),
                   'importance': event.importance} for event in
                  Event.objects.filter(date__gte=datetime.now() - timedelta(weeks=12))]

        return Response(data={'events': events})