from rest_framework import status
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.views import APIView

from firebase_auth.authentication import FirebaseAuthentication
from posts.models import Post, Reply
from posts.serializers import PostSerializer


class PostList(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request):
        posts = Post.objects.all()
        return Response(posts.values())


class PostCreate(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def post(self, request):
        message = request.data.get('message')
        image = request.data.get('image')

        if not message:
            return Response({'message': 'Please provide a message'}, status=status.HTTP_400_BAD_REQUEST)

        post = Post.objects.create(message=message, image=image)
        serializer = PostSerializer(post)
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class ReplyView(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request, post_id):
        post = Post.objects.get(id=post_id)
        return Response(post.replies.values())

    def post(self, request, post_id):
        message = request.data.get('message')

        if not message:
            return Response({'message': 'Please provide a message'}, status=status.HTTP_400_BAD_REQUEST)

        post = Post.objects.get(id=post_id)
        post.replies.create(message=message)
        return Response({'message': 'Reply created'}, status=status.HTTP_201_CREATED)
