import random

from django.contrib.auth.models import User
from django.core.management import BaseCommand

from accounts.models import Profile
from workers.models import Worker


class Command(BaseCommand):
    def handle(self, *args, **kwargs):
        Worker.objects.all().delete()
        Profile.objects.all().delete()
        User.objects.all().delete()

        user_list = []
        uid_dict = {
            'user2@email.com': '0rewtttEpygUZVMDErMtXD041NG3',
            'user1@email.com': 'jRNNUqlmXZcqGZgpWY6sZ1d5ycv2',
            'nuray.akar2000@gmail.com': 'Q8n6STRVJKXtTWOXETsIDzmgoki2',
            'orhun@email.com': '1JH9CSCO6XMrFPwHY90F6NUXQbC3',
            'a@a.com': 'ke4Sa3e5HPVfSHurUqIMfs2PzuG2',
            'test@test.com': 'Q496oKA25scHptLYcM6JbzbxWoO2',
            'test@email.com': 'O3PfeXoAJqOpDZKNDAX65Ys2W9Z2',
            'app.astarte@gmail.com': 'CWEaTZSAWuZ0MBuIRV99gkVwITN2',
            'a.erengenis@gmail.com': '0w56swXRI8aEiJIIVGI4h2OdrPv1',
        }

        names = ["Alice", "Bob", "Charlie", "David", "Emma", "Frank", "Grace", "Henry", "Isabella", "Jack"]
        surnames = ["Smith", "Johnson", "Williams", "Jones", "Brown", "Davis", "Miller", "Wilson", "Moore", "Taylor"]
        user_types = ['F', 'F', 'A', 'A', 'W', 'W', 'W', 'F', 'W', 'W']
        random.shuffle(names)
        random.shuffle(surnames)
        random.shuffle(user_types)

        i = 0
        for email, uid in uid_dict.items():
            user = User.objects.create(email=email, username=uid, first_name=names[i], last_name=surnames[i])
            profile = user.profile
            profile.user_type = user_types[i]
            profile.save()
            i += 1






