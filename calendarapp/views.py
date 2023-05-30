from datetime import datetime, timedelta

from django.http import HttpResponse
from firebase_admin import messaging
from rest_framework import status
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from calendarapp.models import Event, CustomEvent
from firebase_auth.authentication import FirebaseAuthentication


class CalendarDataAPI(APIView):
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):

        events = [{'title': event.title, 'event_type': event.type, 'date': event.date.strftime('%Y-%m-%d'),
                   'importance': event.importance} for event in
                  Event.objects.filter(date__gte=datetime.now() - timedelta(weeks=12))]

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


class SendTokenAPI(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        if request.method == 'POST':
            self.token = request.POST.get('token')
            # self.send_notification()
            # TODO - save the token to a database
            return HttpResponse('Token received!')
        else:
            return HttpResponse('Invalid request method!')

    def send_notification(self):
        registration_token = self.token
        title = 'Test Notification'
        body = 'This is a test notification from Django!'
        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=body,
            ),
            token=registration_token,
        )
        response = messaging.send(message)
        print('Successfully sent message:', response)
