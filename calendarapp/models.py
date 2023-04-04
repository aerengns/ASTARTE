from django.db import models


class Event(models.Model):
    # Split watering event to increase and decrease
    WATER_EVENT = 0
    FROST_EVENT = 1

    EVENT_TYPE_CHOICES = (
        (WATER_EVENT, 'Watering Event'),
        (FROST_EVENT, 'Frost Event')
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

