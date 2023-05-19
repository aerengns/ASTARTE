import base64
import io

from PIL import Image
from django.core.files.base import ContentFile
from django.forms import model_to_dict
from django.http import HttpResponseBadRequest, HttpResponse
from firebase_admin import auth
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.permissions import AllowAny

# Create your views here.
from rest_framework.views import APIView
from rest_framework.response import Response

from accounts.models import Profile
from firebase_auth.authentication import FirebaseAuthentication


class GetCurrentUser(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def post(self, request):
        token = request.data['token']
        if not token:
            return None
        decoded_token = auth.verify_id_token(token)
        firebase_uid = decoded_token.get('uid')
        user_profile = Profile.objects.select_related('user').get(user__username=firebase_uid)
        profile_dict = model_to_dict(user_profile)

        image = Image.open(user_profile.profile_photo)
        img_byte_arr = io.BytesIO()
        image.save(img_byte_arr, format='PNG')
        img_byte_arr = img_byte_arr.getvalue()
        encoded_image = base64.b64encode(img_byte_arr).decode('utf-8')
        profile_dict['profile_photo'] = encoded_image

        # Get or create a Django user with the Firebase UID as the username
        return Response(profile_dict)


class SaveProfile(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    @staticmethod
    def save_base64_image(image_data, image_field):
        # Decode the base64 string into binary data
        decoded_image = base64.b64decode(image_data)

        # Create a ContentFile object from the binary data
        content_file = ContentFile(decoded_image)

        # Assign the ContentFile to the ImageField
        image_field.save('my_image.jpg', content_file)

    def post(self, request):
        token = request.META.get('HTTP_AUTHORIZATION')
        decoded_token = auth.verify_id_token(token)
        firebase_uid = decoded_token.get('uid')
        try:
            user_profile = Profile.objects.select_related('user').get(user__username=firebase_uid)
            user_profile.name = request.data.get('name')
            user_profile.surname = request.data.get('surname')
            user_profile.email = request.data.get('email')
            user_profile.about = request.data.get('about')
            image_data = request.data.get('profile_photo')
            if image_data:
                self.save_base64_image(image_data, user_profile.profile_photo)

            user_profile.save()
        except Profile.DoesNotExist:
            return HttpResponseBadRequest("Failed!")
        return HttpResponse("Success!")
