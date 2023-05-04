from rest_framework import serializers
from .models import FarmParcelReport, Farm


class BooleanAsIntegerField(serializers.IntegerField):
    def to_representation(self, value):
        if value is None:
            return None
        return int(value)

class FarmParcelReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = FarmParcelReport
        fields = '__all__'


class FarmSerializer(serializers.ModelSerializer):
    is_active = BooleanAsIntegerField()
    class Meta:
        model = Farm
        fields = '__all__'

