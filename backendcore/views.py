import os

from django.core.files.base import ContentFile
from django.core.files.storage import default_storage
from django.http import Http404

from rest_framework import status
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from rest_framework.views import APIView

from backendapp import settings
from backendcore.models import FarmParcelReport, Farm
from backendcore.serializers import FarmParcelReportSerializer, FarmSerializer

from rest_framework.permissions import IsAuthenticated

from firebase_auth.authentication import FirebaseAuthentication


# Create your views here.

class HelloDjango(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        print('Request recevied')

        return Response('Hello from ASTARTE!')

    def post(self, request, *args, **kwargs):
        print('Request POST received')
        data = request.FILES['yourPictureKey']  # or self.files['image'] in your form

        path = default_storage.save('tmp/tomatoes.png', ContentFile(data.read()))
        tmp_file = os.path.join(settings.MEDIA_ROOT, path)

        from mmdet.apis import init_detector, inference_detector, show_result_pyplot
        config_file = os.path.abspath("backendcore/mmdetection/configs/mask_rcnn/mask_rcnn_r50_fpn_1x_coco.py")
        checkpoint_file = os.path.abspath("backendcore/mmdetection/checkpoints/laboro_tomato_48ep.pth")
        print(config_file)
        print(checkpoint_file)

        # build the model from a config file and a checkpoint file
        model = init_detector(config_file, checkpoint_file, device='cpu')

        # test a single image
        img_path = os.path.abspath("uploads/")
        img = img_path + '/' + path
        result = inference_detector(model, img)

        ripening_dict = {0: 1,
                         1: 0.5,
                         2: 0,
                         3: 1,
                         4: 0.5,
                         5: 0}

        number_of_tomatoes_dict = {0: 0,
                                   1: 0,
                                   2: 0,
                                   3: 0,
                                   4: 0,
                                   5: 0}

        total_detection = 0
        total_ripness = 0
        for i, row in enumerate(result[0]):
            num_of_tomato = len(row[row[:, -1] > 0.7])
            total_detection += num_of_tomato
            total_ripness += num_of_tomato * ripening_dict[i]
            number_of_tomatoes_dict[i] += num_of_tomato
        return Response(f"Percentage of ripeness: {100 * total_ripness / total_detection:.2f}%,")
        # f"total number of fully ripened tomatoes: {number_of_tomatoes_dict[0] + number_of_tomatoes_dict[3]},"
        # f"total number of half ripened tomatoes: {number_of_tomatoes_dict[1] + number_of_tomatoes_dict[4]},"
        # f"total number of green tomatoes: {number_of_tomatoes_dict[2] + number_of_tomatoes_dict[5]},")


class ReportDetail(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get_object(self, report_id):
        try:
            return FarmParcelReport.objects.get(id=report_id)
        except FarmParcelReport.DoesNotExist:
            raise Http404

    def get(self, request, report_id):
        report = self.get_object(report_id)
        serializer = FarmParcelReportSerializer(report)
        return Response(serializer.data)

    def put(self, request, report_id):
        report = self.get_object(report_id)
        serializer = FarmParcelReportSerializer(report, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, report_id):
        report = self.get_object(report_id)
        report.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class ReportList(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request, farm_id):
        reports = FarmParcelReport.objects.filter(farm_id=farm_id)
        serializer = FarmParcelReportSerializer(reports, many=True)
        return Response(serializer.data)

    def post(self, request, farm_id):
        serializer = FarmParcelReportSerializer(data=request.data)
        farm = Farm.objects.get(id=farm_id)
        if serializer.is_valid():
            report = serializer.save()
            report.farm = farm
            report.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class FarmDetail(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get_object(self, farm_id):
        try:
            return Farm.objects.get(id=farm_id)
        except Farm.DoesNotExist:
            raise Http404

    def get(self, request, farm_id):
        farm = self.get_object(farm_id)
        serializer = FarmSerializer(farm)
        return Response(serializer.data)

    def put(self, request, farm_id):
        farm = self.get_object(farm_id)
        serializer = FarmSerializer(farm, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, farm_id):
        farm = self.get_object(farm_id)
        farm.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class FarmList(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request):
        reports = Farm.objects.filter(owner=request.user)
        serializer = FarmSerializer(reports, many=True)
        return Response(serializer.data)


class GetTokenCredentials(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request):
        content = {
            'user': str(request.user),  # `django.contrib.authentication.User` instance.
            'authentication': str(request.auth),  # None
        }
        return Response(content)
