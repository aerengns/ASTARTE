from django.contrib import admin

from backendcore.models import Farm, FarmParcelReport, FarmParcel

# Register your models here.

admin.site.register(Farm)
admin.site.register(FarmParcel)
admin.site.register(FarmParcelReport)
