from django.db import models
from django.contrib.auth.models import User
from django.db.models.signals import post_save
from django.dispatch import receiver


class AbstractProfile(models.Model):
    name = models.CharField(blank=True, max_length=25)
    surname = models.CharField(blank=True, max_length=25)
    email = models.EmailField()
    about = models.TextField(blank=True)
    profile_photo = models.ImageField(upload_to='profile_photos', blank=True, default='profile_photos/worker_default'
                                                                                      '.png')

    class Meta:
        abstract = True


class Profile(AbstractProfile):
    class UserTypes(models.TextChoices):
        WORKER = 'W', 'Worker'
        FARM_OWNER = 'F', 'Farm Owner'
        AGRONOMIST = 'A', 'Agronomist'

    user = models.OneToOneField(User, on_delete=models.CASCADE)
    user_type = models.CharField(max_length=1, choices=UserTypes.choices, default=UserTypes.WORKER)


@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        Profile.objects.create(user=instance, email=instance.email, name=instance.first_name,
                               surname=instance.last_name)


@receiver(post_save, sender=User)
def save_user_profile(sender, instance, **kwargs):
    instance.profile.save()
