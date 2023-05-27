from django.urls import path
from . import views

urlpatterns = [
    path('posts', views.PostList.as_view(), name='post_list'),
    path('posts/new_post', views.PostCreate.as_view(), name='post_create'),
    path('posts/reply/<int:post_id>', views.ReplyView.as_view(), name='reply'),
]
