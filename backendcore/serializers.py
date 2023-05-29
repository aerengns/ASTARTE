from rest_framework import serializers
from .models import FarmReport, Farm, FarmCornerPoint


class BooleanAsIntegerField(serializers.IntegerField):
    def to_representation(self, value):
        if value is None:
            return None
        return int(value)


class FarmReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = FarmReport
        fields = ['moisture', 'phosphorus', 'potassium', 'nitrogen', 'temperature', 'ph']


class FarmCornerPointSerializer(serializers.ModelSerializer):
    class Meta:
        model = FarmCornerPoint
        fields = ['latitude', 'longitude']


class FarmSerializer(serializers.ModelSerializer):
    is_active = BooleanAsIntegerField()
    latest_farm_report = serializers.SerializerMethodField()
    corner_points = FarmCornerPointSerializer(many=True)

    class Meta:
        model = Farm
        fields = '__all__'

    def get_latest_farm_report(self, obj):
        latest_report = obj.farmreport_set.order_by('-created_at').first()
        if latest_report:
            return FarmReportSerializer(latest_report).data
        return None

    def get_corner_points(self, obj):
        farm_corner_points = obj.farmcornerpoint_set.all()
        if farm_corner_points:
            return FarmCornerPointSerializer(farm_corner_points).data
        return None

    def create(self, validated_data):
        corner_points_data = validated_data.pop('corner_points')
        farm = Farm.objects.create(**validated_data)
        for corner_point_data in corner_points_data:
            FarmCornerPoint.objects.create(farm=farm, **corner_point_data)
        return farm
