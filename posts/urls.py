from django.urls import path
from . import views

urlpatterns = [
    path('posts', views.PostList.as_view(), name='post_list'),
    path('posts/new_post', views.PostCreate.as_view(), name='post_create'),
    path('posts/delete_post/<int:post_id>', views.PostCreate.as_view(), name='post_delete'),
    path('posts/update_post/<int:post_id>', views.PostCreate.as_view(), name='post_update'),
    path('posts/reply/<int:post_id>', views.ReplyView.as_view(), name='reply'),
    path('posts/delete_reply/<int:reply_id>', views.ReplyView.as_view(), name='reply_delete'),
    path('posts/update_reply/<int:reply_id>', views.ReplyView.as_view(), name='reply_update'),
]
