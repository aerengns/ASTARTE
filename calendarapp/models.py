from django.db import models


class Event(models.Model):
    INCREASE_IRRIGATION_EVENT = 0
    DECREASE_IRRIGATION_EVENT = 1
    FROST_EVENT = 2
    HEAT_STRESS_EVENT = 3

    EVENT_TYPE_CHOICES = (
        (INCREASE_IRRIGATION_EVENT, 'Increase Irrigation Event'),
        (DECREASE_IRRIGATION_EVENT, 'Decrease Irrigation Event'),
        (FROST_EVENT, 'Frost Event'),
        (HEAT_STRESS_EVENT, 'Heat Stress Event')
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
    # reason = models.CharField(null=True, blank=True, max_length=255)


class CustomEvent(models.Model):
    description = models.CharField(max_length=255)
    date = models.DateTimeField()
