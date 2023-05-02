import datetime

from django.http import HttpResponse
from django.shortcuts import get_object_or_404

from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.views import APIView

from backendcore.models import FarmParcelReport, Farm, FarmParcel
from firebase_auth.authentication import FirebaseAuthentication
from reports.models import FarmParcelReportLog
import json
from datetime import date, timedelta


class BaseReportAPI(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request):
        print('Report request recevied')

        return Response('Hello from ASTARTE!')

    def get_weekly_values(self, key, user):
        current_date = date.today()
        seven_days_before = current_date - timedelta(days=3)
        report_values = FarmParcelReportLog.objects.filter(
            date_collected__gte=seven_days_before,
            farm__owner__username=user,
        ).order_by('date_collected')
        days = []
        for data in report_values:
            day = data.date_collected
            days.append(day.strftime("%A"))
        return report_values.values_list(key, flat=True), days

    def get_weekly_values_for_multiple_keys(self, keys, user):
        current_date = date.today()
        seven_days_before = current_date - timedelta(days=7)
        report_values = FarmParcelReportLog.objects.filter(
            date_collected__gte=seven_days_before,
            farm__owner__username=user,
        ).order_by('date_collected')
        days = []
        for data in report_values:
            day = data.date_collected
            days.append(day.strftime("%A"))
        return report_values.values_list(keys[0], flat=True), report_values.values_list(keys[1], flat=True),\
            report_values.values_list(keys[2], flat=True), days

class HumidityReportAPI(BaseReportAPI):

    def post(self, request, *args, **kwargs):
        user = request.user
        humidity_levels, days = self.get_weekly_values('moisture', user)
        return Response(data={'days': days, 'humidity_levels': humidity_levels})


class NPKReportAPI(BaseReportAPI):

    def post(self, request, *args, **kwargs):
        user = request.user
        n_values, p_values, k_values, days = self.get_weekly_values_for_multiple_keys(['nitrogen',
                                                                                       'phosphorus',
                                                                                       'potassium'],
                                                                                      user)

        return Response(data={'days': days, 'n_values': n_values, 'p_values': p_values, 'k_values': k_values})


class TemperatureReportAPI(BaseReportAPI):

    def post(self, request, *args, **kwargs):
        user = request.user
        temperatures, days = self.get_weekly_values('temperature', user)
        return Response(data={'days': days, 'temperatures': temperatures})


class SaveReportData(APIView):
    permission_classes = [AllowAny]
    authentication_classes = []

    def get(self, request, *args):
        return Response("get recieved")

    def post(self, request):
        byte_object = request.body
        string_object = byte_object.decode('utf-8')
        object_dict = json.loads(string_object)
        farm = get_object_or_404(Farm, name=object_dict.pop('farmName'))
        parcel = get_object_or_404(FarmParcel, no=object_dict.pop('parcelNo'))
        constants = {'farm_id': farm.id, 'parcel_id': parcel.id}
        date = object_dict.pop('formDate')
        object_dict.update({'date_collected': datetime.datetime.strptime(date, '%d-%m-%Y').strftime('%Y-%m-%d')})
        obj, created = FarmParcelReport.objects.update_or_create(
            farm_id=farm.id,
            parcel_id=parcel.id,
            defaults=object_dict,
        )
        object_dict.update(constants)
        log = FarmParcelReportLog(**object_dict)
        log.save()

        if created:
            message = "new report is created"
        else:
            message = f"farm {farm.name} with parcel_no:{parcel.no} is changed"
        print(message)
        return Response(message)

