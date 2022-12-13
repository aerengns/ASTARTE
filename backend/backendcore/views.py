import os

from django.core.files.base import ContentFile
from django.core.files.storage import default_storage
from django.views import View
from django.core.files import File  # you need this somewhere
import urllib

from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from rest_framework.views import APIView

from backendapp import settings


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
        config_file = '/Users/kursat/Desktop/Flutter/IntegrationTest/backend/backendcore/mmdetection/configs/mask_rcnn/mask_rcnn_r50_fpn_1x_coco.py'
        checkpoint_file = '/Users/kursat/Desktop/Flutter/IntegrationTest/backend/backendcore/mmdetection/checkpoints/laboro_tomato_48ep.pth'

        # build the model from a config file and a checkpoint file
        model = init_detector(config_file, checkpoint_file, device='cpu')

        # test a single image
        img = f'/Users/kursat/Desktop/Flutter/IntegrationTest/backend/uploads/{path}'
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
        return Response(f"Percentage of ripeness: {100 * total_ripness / total_detection:.2f}%,"
        f"total number of fully ripened tomatoes: {number_of_tomatoes_dict[0] + number_of_tomatoes_dict[3]},"
        f"total number of half ripened tomatoes: {number_of_tomatoes_dict[1] + number_of_tomatoes_dict[4]},"
        f"total number of green tomatoes: {number_of_tomatoes_dict[2] + number_of_tomatoes_dict[5]},")