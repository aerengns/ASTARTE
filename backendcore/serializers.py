from rest_framework import serializers
from .models import FarmReport, Farm


class BooleanAsIntegerField(serializers.IntegerField):
    def to_representation(self, value):
        if value is None:
            return None
        return int(value)


class FarmReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = FarmReport
        fields = ['moisture', 'phosphorus', 'potassium', 'nitrogen', 'temperature', 'ph']


class FarmSerializer(serializers.ModelSerializer):
    is_active = BooleanAsIntegerField()
    latest_farm_report = serializers.SerializerMethodField()

    class Meta:
        model = Farm
        fields = '__all__'

    def get_latest_farm_report(self, obj):
        latest_report = obj.farmreport_set.order_by('-created_at').first()
        if latest_report:
            return FarmReportSerializer(latest_report).data
        return None
