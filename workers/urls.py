from django.urls import path
from . import views

urlpatterns = [
    path('workers_data', views.WorkerDataAPI.as_view(), name='workers-data'),
    path('jobs_data', views.JobDataAPI.as_view(), name='jobs-data'),
    path('job_finish', views.JobFinishAPI.as_view(), name='jobs-finish'),
    path('related_farms', views.WorkerRelatedFarmsAPI.as_view(), name='related-farms'),
]
