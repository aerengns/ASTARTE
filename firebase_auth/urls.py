from django.urls import path
from .views import GetCurrentUser

urlpatterns = [
    path('get_user', GetCurrentUser.as_view(), name='get-current-user'),
]
