from django.urls import path
from .views import SampleView

urlpatterns = [
    path('sample/', SampleView.as_view(), name='sample_view'),
]
