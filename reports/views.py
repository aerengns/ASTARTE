import datetime

from django.db.models import Avg

from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.views import APIView

from backendcore.models import FarmReport, Farm
from firebase_auth.authentication import FirebaseAuthentication
from reports.models import FarmReportLog
import json
from datetime import date, timedelta


class BaseReportAPI(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get_weekly_values(self, key, user, farm_id, start_date, end_date):
        current_date = date.today()
        if not start_date:
            start_date = current_date
        if not end_date:
            end_date = current_date - timedelta(days=7)
        report_values = FarmReportLog.objects.filter(
            date_collected__range=(start_date, end_date),
            farm__owner__username=user,
            farm_id=farm_id,
        ).values('date_collected').annotate(avg=Avg(key)).order_by('date_collected')
        days = []
        for data in report_values:
            day = data['date_collected']
            days.append(day.strftime('%Y-%m-%d'))
        return report_values.values_list('avg', flat=True), days

    def get_weekly_values_for_multiple_keys(self, keys, user, farm_id, start_date, end_date):
        current_date = date.today()
        if not start_date:
            start_date = current_date
        if not end_date:
            end_date = current_date - timedelta(days=7)
        report_values = FarmReportLog.objects.filter(
            date_collected__range=(start_date, end_date),
            farm__owner__username=user,
            farm_id=farm_id
        ).order_by('date_collected')
        days = []
        averages_1 = report_values.values('date_collected').annotate(avg=Avg(keys[0]))
        averages_2 = report_values.values('date_collected').annotate(avg=Avg(keys[1]))
        averages_3 = report_values.values('date_collected').annotate(avg=Avg(keys[2]))
        for data in averages_1:
            day = data['date_collected']
            days.append(day.strftime('%Y-%m-%d'))
        return averages_1.values_list('avg', flat=True), averages_2.values_list('avg', flat=True), \
            averages_3.values_list('avg', flat=True), days


class HumidityReportAPI(BaseReportAPI):

    def get(self, request, *args, **kwargs):
        farm_id = int(kwargs.get('farm_id'))
        try:
            farm = Farm.objects.get(id=farm_id)
        except:
            Response(status=404)
        if 'start_date' in request.GET and 'end_date' in request.GET:
            start_date = datetime.datetime.strptime(request.GET['start_date'], '%Y-%m-%d').date()
            end_date = datetime.datetime.strptime(request.GET['end_date'], '%Y-%m-%d').date()
        user = request.user
        humidity_levels, days = self.get_weekly_values('moisture', user, farm_id, start_date, end_date)
        return Response(data={'days': days, 'humidity_levels': humidity_levels})


class NPKReportAPI(BaseReportAPI):

    def get(self, request, *args, **kwargs):
        farm_id = int(kwargs.get('farm_id'))
        try:
            farm = Farm.objects.get(id=farm_id)
        except:
            Response(status=404)
        if 'start_date' in request.GET and 'end_date' in request.GET:
            start_date = datetime.datetime.strptime(request.GET['start_date'], '%Y-%m-%d').date()
            end_date = datetime.datetime.strptime(request.GET['end_date'], '%Y-%m-%d').date()
        user = request.user
        n_values, p_values, k_values, days = self.get_weekly_values_for_multiple_keys(['nitrogen',
                                                                                       'phosphorus',
                                                                                       'potassium'],
                                                                                      user, farm_id, start_date,
                                                                                      end_date)

        return Response(data={'days': days, 'n_values': n_values, 'p_values': p_values, 'k_values': k_values})


class TemperatureReportAPI(BaseReportAPI):

    def get(self, request, *args, **kwargs):
        farm_id = int(kwargs.get('farm_id'))
        try:
            farm = Farm.objects.get(id=farm_id)
        except:
            Response(status=404)
        if 'start_date' in request.GET and 'end_date' in request.GET:
            start_date = datetime.datetime.strptime(request.GET['start_date'], '%Y-%m-%d').date()
            end_date = datetime.datetime.strptime(request.GET['end_date'], '%Y-%m-%d').date()
        user = request.user
        temperatures, days = self.get_weekly_values('temperature', user, farm_id, start_date, end_date)
        return Response(data={'days': days, 'temperatures': temperatures})


class SendFarmList(BaseReportAPI):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request, *args, **kwargs):
        user = request.user
        farms = Farm.objects.filter(owner__username=user, is_active=1).values_list('name', 'id')
        return Response(data=farms)


class LogSenderAPI(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request, *args, **kwargs):
        farm_id = int(kwargs.get('farm_id'))
        try:
            farm = Farm.objects.get(id=farm_id)
        except Farm.DoesNotExist:
            return Response(status=404)

        user = request.user
        report_values = FarmReportLog.objects.filter(
            farm__owner__username=user,
            farm_id=farm_id,
        ).order_by('-date_collected')

        if 'start_date' in request.GET and 'end_date' in request.GET:
            start_date = datetime.datetime.strptime(request.GET['start_date'], '%Y-%m-%d').date()
            end_date = datetime.datetime.strptime(request.GET['end_date'], '%Y-%m-%d').date()
            report_values = report_values.filter(date_collected__range=(start_date, end_date))

        logs = report_values.values(
            'id',
            'farm__name',
            'parcel',
            'moisture',
            'phosphorus',
            'potassium',
            'nitrogen',
            'temperature',
            'ph',
            'latitude',
            'longitude',
            'date_collected'
        )

        return Response(data=logs)


class SaveReportData(APIView):
    permission_classes = [AllowAny]
    authentication_classes = []

    def get(self, request, *args):
        return Response("get recieved")

    def post(self, request):
        byte_object = request.body
        string_object = byte_object.decode('utf-8')
        object_dict = json.loads(string_object)
        object_dict.pop('parcelNo')
        date = object_dict.pop('formDate')
        farm_name = object_dict.pop('farmName')
        object_dict.update({'farm': Farm.objects.get(name=farm_name)})
        object_dict.update({'date_collected': datetime.datetime.strptime(date, '%d-%m-%Y').strftime('%Y-%m-%d')})
        obj = FarmReport.objects.create(**object_dict)
        obj.save()
        log = FarmReportLog(**object_dict)
        log.save()
        message = f"New report created for farm: {farm_name}"
        return Response(message)
