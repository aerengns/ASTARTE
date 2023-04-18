from django.db import models

from calendarapp.models import Event


class Worker(models.Model):
    class Title(models.TextChoices):
        WORKER = 'Worker', 'Worker'
        AG_ENGINEER = 'Agricultural Engineer', 'Agr Eng'
        OWNER = 'Farm Owner', 'Owner'

    name = models.CharField(blank=True, max_length=25)
    surname = models.CharField(blank=True, max_length=25)
    email = models.EmailField()
    about = models.TextField(blank=True)
    event = models.ForeignKey(Event, on_delete=models.PROTECT, null=True)
    permission_level = models.IntegerField(default=0)
    title = models.CharField(choices=Title.choices, default=Title.WORKER, max_length=50)
    profile_photo = models.ImageField(upload_to='profile_photos', blank=True, default='profile_photos/worker_default'
                                                                                      '.png')
