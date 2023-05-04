from django.urls import path
from . import views

urlpatterns = [
    path('workers_data', views.WorkerDataAPI.as_view(), name='workers-data'),
]
