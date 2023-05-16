from django.db import models

# Create your models here.
from backendcore.models import Farm, BaseAbstractModel


class FarmReportLog(BaseAbstractModel):
    farm = models.ForeignKey(Farm, on_delete=models.CASCADE, blank=True)
    moisture = models.FloatField(null=True, blank=True)
    phosphorus = models.FloatField(null=True, blank=True)
    potassium = models.FloatField(null=True, blank=True)
    nitrogen = models.FloatField(null=True, blank=True)
    temperature = models.FloatField(null=True, blank=True)
    ph = models.FloatField(null=True, blank=True)
    latitude = models.FloatField(null=True, blank=True)
    longitude = models.FloatField(null=True, blank=True)
    date_collected = models.DateTimeField()
