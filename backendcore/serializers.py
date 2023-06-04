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
        latest_report = obj.farmreport_set.order_by('-created_at').first()
        if latest_report:
            return FarmReportSerializer(latest_report).data
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
