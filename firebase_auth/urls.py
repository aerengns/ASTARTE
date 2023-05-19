from django.urls import path
from .views import GetCurrentUser, SaveProfile

urlpatterns = [
    path('get_user', GetCurrentUser.as_view(), name='get-current-user'),
    path('save_profile', SaveProfile.as_view(), name='save-profile'),
]
