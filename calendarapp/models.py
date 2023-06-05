from django.db import models

from accounts.models import Profile
from backendcore.models import Farm


class Event(models.Model):
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

    CRITICAL_EVENT = 0
    MODERATE_EVENT = 1
    SAFE_EVENT = 2

    EVENT_IMPORTANCE_CHOICES = (
        (CRITICAL_EVENT, 'Critical Importance Event'),
        (MODERATE_EVENT, 'Moderate Importance Event'),
        (SAFE_EVENT, 'Safe Event')
    )

    title = models.CharField(max_length=255)
    type = models.IntegerField(choices=EVENT_TYPE_CHOICES)
    date = models.DateTimeField()
    importance = models.IntegerField(choices=EVENT_IMPORTANCE_CHOICES)
    assigner = models.ForeignKey(Profile, on_delete=models.PROTECT, null=True)
    farm = models.ForeignKey(Farm, on_delete=models.CASCADE)
    description = models.CharField(null=True, blank=True, max_length=255)
