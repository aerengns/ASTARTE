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
