from django.urls import path
from . import views

urlpatterns = [
    path('posts', views.PostList.as_view(), name='post_list'),
    path('posts/new_post', views.PostCreate.as_view(), name='post_create'),
]
