from django.db.models import Avg
from rest_framework import serializers
from rest_framework.fields import CurrentUserDefault

from .models import FarmReport, Farm, FarmCornerPoint


class BooleanAsIntegerField(serializers.IntegerField):
    def to_representation(self, value):
        if value is None:
            return None
        return int(value)


class FarmReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = FarmReport
        fields = ['moisture', 'phosphorus', 'potassium', 'nitrogen', 'temperature', 'ph', 'date_collected']


class FarmCornerPointSerializer(serializers.ModelSerializer):
    class Meta:
        model = FarmCornerPoint
        fields = ['latitude', 'longitude']


class CreateFarmSerializer(serializers.Serializer):
    name = serializers.CharField(max_length=225, required=True)
    cornerPoints = FarmCornerPointSerializer(many=True, required=True)

    def create(self, validated_data):
        corner_points_data = validated_data.pop('cornerPoints')
        farm = Farm.objects.create(name=validated_data['name'], owner_id=self.context['user_id'])
        for corner_point_data in corner_points_data:
            FarmCornerPoint.objects.create(farm=farm, **corner_point_data)
        return farm


class FarmSerializer(serializers.ModelSerializer):
    is_active = BooleanAsIntegerField()
    latest_farm_report = serializers.SerializerMethodField()
    farmcornerpoint_set = FarmCornerPointSerializer(many=True)
    farm_corner = serializers.SerializerMethodField()

    class Meta:
        model = Farm
        fields = '__all__'

    def get_latest_farm_report(self, obj):
        latest_report = obj.farmreport_set.order_by('-date_collected').first()
        if latest_report:
            average_report = get_average_report(latest_report)
            return FarmReportSerializer(average_report).data
        return None

    def get_farmcornerpoint_set(self, obj):
        farm_corner_points = obj.farmcornerpoint_set.all()
        if farm_corner_points:
            return FarmCornerPointSerializer(farm_corner_points).data
        return None

    def get_farm_corner(self, obj):
        farm_corner_point = obj.farmcornerpoint_set.first()
        if farm_corner_point:
            return FarmCornerPointSerializer(farm_corner_point).data
        return None

    def create(self, validated_data):
        corner_points_data = validated_data.pop('corner_points')
        farm = Farm.objects.create(**validated_data)
        for corner_point_data in corner_points_data:
            FarmCornerPoint.objects.create(farm=farm, **corner_point_data)
        return farm


def get_average_report(latest_report):
    reports_same_day_avgs = FarmReport.objects.filter(
        farm_id=latest_report.farm.id,
        date_collected__day=latest_report.date_collected.day,
        date_collected__month=latest_report.date_collected.month,
        date_collected__year=latest_report.date_collected.year
    ).aggregate(
        Avg('moisture'),
        Avg('phosphorus'),
        Avg('potassium'),
        Avg('nitrogen'),
        Avg('ph'))
    return FarmReport(
        farm=latest_report.farm,
        moisture=reports_same_day_avgs['moisture__avg'],
        phosphorus=reports_same_day_avgs['phosphorus__avg'],
        potassium=reports_same_day_avgs['potassium__avg'],
        nitrogen=reports_same_day_avgs['nitrogen__avg'],
        ph=reports_same_day_avgs['ph__avg'],
        temperature=latest_report.temperature,
        latitude=latest_report.latitude,
        longitude=latest_report.longitude,
        date_collected=latest_report.date_collected,
    )