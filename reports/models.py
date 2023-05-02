from django.db import models

from backendcore.models import Farm, FarmParcel


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


class FarmParcelReportLog(BaseAbstractModel):
    farm = models.ForeignKey(Farm, on_delete=models.CASCADE, blank=True)
    parcel = models.ForeignKey(FarmParcel, on_delete=models.SET_NULL, null=True)
    moisture = models.FloatField(null=True, blank=True)
    phosphorus = models.FloatField(null=True, blank=True)
    potassium = models.FloatField(null=True, blank=True)
    nitrogen = models.FloatField(null=True, blank=True)
    temperature = models.FloatField(null=True, blank=True)
    ph = models.FloatField(null=True, blank=True)
    latitude = models.FloatField(null=True, blank=True)
    longitude = models.FloatField(null=True, blank=True)
    date_collected = models.DateTimeField()
