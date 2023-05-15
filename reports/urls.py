from django.urls import path
from . import views

urlpatterns = [
    path('reports/humidity_report', views.HumidityReportAPI.as_view(), name='humidity_report'),
    path('reports/npk_report', views.NPKReportAPI.as_view(), name='npk_report'),
    path('reports/temperature_report', views.TemperatureReportAPI.as_view(), name='temperature_report'),
    path('reports', views.SaveReportData.as_view(), name='save_report'),
    path('reports/<slug:farm_name>', views.SaveReportData.as_view(), name='save_report'),
]
