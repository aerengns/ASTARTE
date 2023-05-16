from django.db import models


class Post(models.Model):
    image = models.TextField(null=True)
    message = models.TextField(max_length=500)


class Reply(models.Model):
    post = models.ForeignKey(Post, on_delete=models.CASCADE, related_name='replies')
    message = models.TextField(max_length=500)
