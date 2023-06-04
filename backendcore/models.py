from django.core.validators import MinValueValidator, MaxValueValidator
from django.db import models

from django.contrib.auth.models import User


class BaseAbstractModel(models.Model):
    """
    An abstract base class model that provides self-updating
    ``created_at`` and ``updated_at`` fields.
    Also has ``is_active`` field.
    """
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        abstract = True


class Farm(BaseAbstractModel):
    name = models.CharField(max_length=100)
    area = models.FloatField(null=True, blank=True)
    owner = models.ForeignKey(User, on_delete=models.CASCADE)


class FarmCornerPoint(BaseAbstractModel):
    farm = models.ForeignKey(Farm, on_delete=models.CASCADE)
    latitude = models.FloatField(validators=[MinValueValidator(-90.0), MaxValueValidator(90.0)])
    longitude = models.FloatField(validators=[MinValueValidator(-180.0), MaxValueValidator(180.0)])


class FarmReport(BaseAbstractModel):
    farm = models.ForeignKey(Farm, on_delete=models.CASCADE, blank=True)
    moisture = models.FloatField(null=True, blank=True)
    phosphorus = models.FloatField(null=True, blank=True)
    potassium = models.FloatField(null=True, blank=True)
    nitrogen = models.FloatField(null=True, blank=True)
    temperature = models.FloatField(null=True, blank=True)
    latitude = models.FloatField(null=True, blank=True)
    longitude = models.FloatField(null=True, blank=True)
    ph = models.FloatField(null=True, blank=True)
    date_collected = models.DateTimeField()
