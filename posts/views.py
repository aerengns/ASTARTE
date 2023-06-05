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
        username = request.data.get('username')

        if not message:
            return Response({'message': 'Please provide a message'}, status=status.HTTP_400_BAD_REQUEST)

        post = Post.objects.create(message=message, image=image, username=username)
        serializer = PostSerializer(post)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    def delete(self, request, post_id):
        post = Post.objects.get(id=post_id)
        post.delete()
        return Response({'message': 'Post deleted'}, status=status.HTTP_200_OK)

    def put(self, request, post_id):
        post = Post.objects.get(id=post_id)
        message = request.data

        if not message:
            return Response({'message': 'Please provide a message'}, status=status.HTTP_400_BAD_REQUEST)

        post.message = message
        post.save()
        serializer = PostSerializer(post)
        return Response(serializer.data, status=status.HTTP_200_OK)


class ReplyView(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [FirebaseAuthentication]

    def get(self, request, post_id):
        post = Post.objects.get(id=post_id)
        return Response(post.replies.values())

    def post(self, request, post_id):
        message = request.data.get('message')
        username = request.data.get('username')

        if not message:
            return Response({'message': 'Please provide a message'}, status=status.HTTP_400_BAD_REQUEST)

        post = Post.objects.get(id=post_id)
        post.replies.create(message=message, username=username)
        return Response({'message': 'Reply created'}, status=status.HTTP_201_CREATED)

    def delete(self, request, reply_id):
        reply = Reply.objects.get(id=reply_id)
        reply.delete()
        return Response({'message': 'Reply deleted'}, status=status.HTTP_200_OK)

    def put(self, request, reply_id):
        reply = Reply.objects.get(id=reply_id)
        message = request.data

        if not message:
            return Response({'message': 'Please provide a message'}, status=status.HTTP_400_BAD_REQUEST)

        reply.message = message
        reply.save()
        return Response({'message': 'Reply updated'}, status=status.HTTP_200_OK)