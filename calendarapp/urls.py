from django.urls import path
from . import views

urlpatterns = [
    path('calendar_data', views.CalendarDataAPI.as_view(), name='calendar-data'),
]
