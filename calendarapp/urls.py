from django.urls import path
from . import views

urlpatterns = [
    path('calendar_data', views.CalendarDataAPI.as_view(), name='calendar-data'),
    path('send_token', views.SendTokenAPI.as_view(), name='send_token'),
    path('create_event', views.CreateEventAPI.as_view(), name='create_event'),
]
