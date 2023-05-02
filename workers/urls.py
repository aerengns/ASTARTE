from django.urls import path
from . import views

urlpatterns = [
    path('workers_data', views.WorkerDataAPI.as_view(), name='workers-data'),
    path('jobs_data', views.JobDataAPI.as_view(), name='jobs-data'),
]
