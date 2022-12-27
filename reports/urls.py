from django.urls import path
from . import views

urlpatterns = [
    path('humidity_report', views.HumidityReportAPI.as_view(), name='humidity_report'),
]
