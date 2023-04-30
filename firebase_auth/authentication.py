from django.contrib.auth.models import User
from rest_framework.authentication import BaseAuthentication
import firebase_admin
from firebase_admin import auth, credentials
from rest_framework.exceptions import AuthenticationFailed
from django.conf import settings

firebase_creds = credentials.Certificate(settings.FIREBASE_CONFIG)

firebase_app = firebase_admin.initialize_app(firebase_creds)


class FirebaseAuthentication(BaseAuthentication):
    def authenticate(self, request):
        auth_header = request.META.get('HTTP_AUTHORIZATION')
        if not auth_header:
            return None
        try:
            token = auth_header.split(' ')[1]
            if len(token.split('.')) != 3:
                raise AuthenticationFailed("Invalid token structure.")
            decoded_token = auth.verify_id_token(token)
            firebase_uid = decoded_token.get('uid')

            # Get or create a Django user with the Firebase UID as the username
            user, created = User.objects.get_or_create(username=firebase_uid)

            return user, None
        except Exception as e:
            raise AuthenticationFailed(str(e))
