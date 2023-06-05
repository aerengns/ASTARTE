from django.db import models
from django.db.models.signals import post_save
from django.dispatch import receiver

from accounts.models import Profile, AbstractProfile
from backendcore.models import Farm, BaseAbstractModel
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
    worker = instance.worker
    worker.email = instance.email
    worker.name = instance.name
    worker.surname = instance.surname
    worker.about = instance.about
    worker.profile_photo = instance.profile_photo
    worker.save()


class WorkerActivityLog(BaseAbstractModel):
    INCREASE_IRRIGATION_EVENT = 0
    DECREASE_IRRIGATION_EVENT = 1
    FROST_EVENT = 2
    HEAT_STRESS_EVENT = 3
    CUSTOM_EVENT = 4

    EVENT_TYPE_CHOICES = (
        (INCREASE_IRRIGATION_EVENT, 'Increase Irrigation Event'),
        (DECREASE_IRRIGATION_EVENT, 'Decrease Irrigation Event'),
        (FROST_EVENT, 'Frost Event'),
        (HEAT_STRESS_EVENT, 'Heat Stress Event'),
        (CUSTOM_EVENT, 'Custom Event'),
    )

    worker = models.ForeignKey(Worker, on_delete=models.CASCADE)
    tittle = models.CharField(max_length=255)
    type = models.TextField(choices=EVENT_TYPE_CHOICES, max_length=255)
    date_finished = models.DateField()
    farm = models.ForeignKey(Farm, on_delete=models.CASCADE)
    description = models.CharField(null=True, blank=True, max_length=255)
