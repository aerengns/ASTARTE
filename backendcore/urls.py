from django.urls import path
from . import views

urlpatterns = [
    path('hello', views.HelloDjango.as_view(), name='hello'),
]
