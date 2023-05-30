from django.urls import path
from . import views

urlpatterns = [
    path('send_token', views.SendTokenAPI.as_view(), name='send_token'),
]
