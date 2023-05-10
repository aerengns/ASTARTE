from django.db import models


class Post(models.Model):
    image = models.TextField(null=True)
    message = models.TextField(max_length=500)
