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


class FarmParcel(BaseAbstractModel):
    farm = models.ForeignKey(Farm, on_delete=models.CASCADE)
    no = models.PositiveIntegerField(default=1, blank=True)


class Worker(User):
    works_at = models.ForeignKey(Farm, on_delete=models.SET_NULL, null=True)


class FarmParcelReport(BaseAbstractModel):
    farm = models.ForeignKey(Farm, on_delete=models.CASCADE, blank=True)
    parcel = models.ForeignKey(FarmParcel, on_delete=models.SET_NULL, null=True)
    moisture = models.FloatField(null=True, blank=True)
    phosphorus = models.FloatField(null=True, blank=True)
    potassium = models.FloatField(null=True, blank=True)
    nitrogen = models.FloatField(null=True, blank=True)
    temperature = models.FloatField(null=True, blank=True)
    ph = models.FloatField(null=True, blank=True)
    date_collected = models.DateTimeField()


class Task(BaseAbstractModel):
    worker = models.ForeignKey(Worker, on_delete=models.SET_NULL, null=True)
    farm = models.ForeignKey(Farm, on_delete=models.SET_NULL, null=True)
    parcel_no = models.PositiveIntegerField(default=0)
    is_completed = models.BooleanField(default=False)


class Comment(BaseAbstractModel):
    author = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
    subject = models.CharField(max_length=100)
    content = models.TextField(max_length=400)

    class Meta:
        abstract = True


class FarmComment(Comment):
    farm = models.ForeignKey(Farm, on_delete=models.CASCADE)


class TaskComment(Comment):
    task = models.ForeignKey(Task, on_delete=models.SET_NULL, null=True)


class FarmPhoto(BaseAbstractModel):
    farm = models.ForeignKey(Farm, on_delete=models.SET_NULL, null=True)
    taken_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
    message = models.TextField(max_length=300)
    photo = models.ImageField(upload_to='uploads/% Y/% m/% d/')
