import base64
import os
import random

from django.core.management import BaseCommand

from posts.models import Post, Reply
from accounts.models import Profile


def create_posts():
    names = Profile.objects.values_list('name', flat=True)
    surnames = Profile.objects.values_list('surname', flat=True)
    usernames = [f'{name} {surname}' for name, surname in zip(names, surnames)]
    messages = {
        'bacterial-wilt': 'Does these plants need water or is this a disease?',
        'late-blight': 'What can I do to help this plant?',
        'septoria-leaf-spot': 'The leafs of this plant are turning yellow, what can I do?',
        'spider-mites': 'What are these bugs?',
    }

    replies = {
        'bacterial-wilt': 'This looks like a disease caused by bacteria.',
        'late-blight': 'This is late blight disease.',
        'septoria-leaf-spot': 'This is septoria leaf spot disease.',
        'spider-mites': 'These are spider mites.',
    }

    for filename in os.listdir('posts/management/post_images'):
        with open(f'posts/management/post_images/{filename}', 'rb') as f:
            image = base64.b64encode(f.read()).decode('utf-8')
            random_username = random.choice(usernames)
            message = messages[filename.split('.')[0]]
            Post.objects.create(message=message, image=image, username=random_username)
            Reply.objects.create(message=replies[filename.split('.')[0]], username=random.choice(usernames),
                                 post_id=Post.objects.last().id)


class Command(BaseCommand):
    help = 'Create posts'

    def handle(self, *args, **options):
        create_posts()
        self.stdout.write(self.style.SUCCESS('Successfully created posts and replies'))
