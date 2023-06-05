from django.urls import path
from . import views

urlpatterns = [
    path('calendar_data', views.CalendarDataAPI.as_view(), name='calendar-data'),
    path('create_event', views.CreateEventAPI.as_view(), name='create_event'),
    path('edit_event', views.EditEventAPI.as_view(), name='edit-event'),
]
