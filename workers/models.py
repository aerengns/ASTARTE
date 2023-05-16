from django.db import models
from django.db.models.signals import post_save
from django.dispatch import receiver

from accounts.models import Profile, AbstractProfile
from calendarapp.models import Event


class Worker(AbstractProfile):
    profile = models.OneToOneField(Profile, on_delete=models.CASCADE)
    event = models.ForeignKey(Event, on_delete=models.PROTECT, null=True)
    permission_level = models.IntegerField(default=0)


@receiver(post_save, sender=Profile)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        Worker.objects.create(profile=instance, email=instance.email, name=instance.name,
                              surname=instance.name, about=instance.about, profile_photo=instance.profile_photo)


@receiver(post_save, sender=Profile)
def save_user_profile(sender, instance, **kwargs):
    instance.worker.save()
