import base64
import os
from random import random, shuffle, choice
from datetime import timedelta

from django.contrib.auth.models import User
from django.core.management import BaseCommand
from django.utils import timezone

from accounts.models import Profile, DeviceToken
from backendcore.models import FarmCornerPoint, FarmReport, Farm
from calendarapp.models import Event
from posts.models import Post, Reply
from reports.models import FarmReportLog
from workers.models import Worker, WorkerActivityLog


def delete_users():
    Worker.objects.all().delete()
    Profile.objects.all().delete()
    User.objects.all().delete()


def create_users():
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
    shuffle(names)
    shuffle(surnames)
    shuffle(user_types)

    i = 0
    for email, uid in uid_dict.items():
        user = User.objects.create(email=email, username=uid, first_name=names[i], last_name=surnames[i])
        profile = user.profile
        profile.user_type = user_types[i]
        profile.save()
        DeviceToken.objects.create(token='dE9_o522R0mP8wAy3EOl6j:APA91bGxogQZLn7anoV9J4yXHagQqJfcVIJvd01nkLDGjqHDEeLaw1LfkViWF4UbdsrCYZyPfhGGRVUO8NAqlrQb4O0cg43JUsbHU4RnhcWmhOkwhLDzr88iX0vd7st-BJ6Ka3-RT2Lc', user=profile)
        i += 1


def worker_activity_create(farm_id=1):
    possible_event_combinations = [[0, 2, 3], [1, 2, 3]]
    titles = {0: 'Low Soil Moisture', 1: 'High Soil Moisture', 2: 'Frost Warning', 3: 'Heat Stress'}
    descriptions = {0: 'Increase Irrigation', 1: 'Decrease Irrigation', 2: 'There May be a Frost', 3: 'Heat Stress'}

    WorkerActivityLog.objects.filter(farm_id=farm_id).delete()

    workers = Worker.objects.filter(profile__user_type=Profile.UserTypes.WORKER).order_by('?')
    try:
        worker = workers[0]
    except:
        return
    for day in range(10):
        curr_index = round(2 * random())
        event_index = possible_event_combinations[day % 2][curr_index]
        WorkerActivityLog.objects.create(worker=worker, tittle=titles[event_index],
                                         type=event_index, farm_id=farm_id,
                                         date_finished=timezone.now() - timedelta(days=day),
                                         description=descriptions[event_index]
                                         )


def calendar_event_create(user, farm_id=1):
    Event.objects.filter(farm_id=farm_id).delete()
    possible_event_combinations = [[0, 2, 3], [1, 2, 3]]
    titles = {0: 'Low Soil Moisture', 1: 'High Soil Moisture', 2: 'Frost Warning', 3: 'Heat Stress'}
    descriptions = {0: 'Increase Irrigation', 1: 'Decrease Irrigation', 2: 'There May be a Frost', 3: 'Heat Stress'}

    for day in range(-15, 15):
        rand = random()
        if rand < 0.3:
            event_create_times = 0
        elif rand < 0.8:
            event_create_times = 1
        else:
            event_create_times = 2
        used_indices = []
        for i in range(event_create_times):
            curr_index = round(2 * random())
            while curr_index in used_indices:
                curr_index = round(2 * random())
            used_indices.append(curr_index)
            event_index = possible_event_combinations[day % 2][curr_index]
            Event.objects.create(farm_id=farm_id, title=titles[event_index],
                                 date=timezone.now() - timedelta(days=day),
                                 type=event_index, importance=round(2 * random()),
                                 assigner=user.profile,
                                 description=descriptions[event_index]
                                 )


def farm_create():
    # 1ST FARM
    users = User.objects.filter(profile__user_type=Profile.UserTypes.FARM_OWNER).order_by('?')

    FarmCornerPoint.objects.filter(farm__owner=users[0]).delete()
    FarmReport.objects.filter(farm__owner=users[0]).delete()
    Farm.objects.filter(owner=users[0]).delete()

    farm1 = Farm.objects.create(name='domates', area=1, owner=users[0])

    farm_id1 = farm1.id

    farm_corners1 = [[29.9999, 39.9999], [30.009, 40.0073], [30.0072, 40.00018],
                     [30.0049, 40.009], [29.99, 40.015]]

    for farm in farm_corners1:
        FarmCornerPoint.objects.create(farm_id=farm_id1, latitude=farm[1], longitude=farm[0])

    sensors1 = [{'longitude': 30.001, 'latitude': 40.001, 'moisture': 50 + 50 * random(), 'p': 2000 * random(),
                 'k': 2000 * random(), 'n': 2000 * random(), 'temp': 20 + 10 * random(), 'ph': 5 + 3 * random()},
                {'longitude': 29.99, 'latitude': 40.005, 'moisture': 50 + 50 * random(), 'p': 2000 * random(),
                 'k': 2000 * random(), 'n': 2000 * random(), 'temp': 20 + 10 * random(), 'ph': 5 + 3 * random()},
                {'longitude': 30.003, 'latitude': 40.005, 'moisture': 50 + 50 * random(), 'p': 2000 * random(),
                 'k': 2000 * random(), 'n': 2000 * random(), 'temp': 20 + 10 * random(), 'ph': 5 + 3 * random()},
                {'longitude': 30.005, 'latitude': 40.007, 'moisture': 50 + 50 * random(), 'p': 2000 * random(),
                 'k': 2000 * random(), 'n': 2000 * random(), 'temp': 20 + 10 * random(), 'ph': 5 + 3 * random()},
                {'longitude': 30.0075, 'latitude': 40.0015, 'moisture': 50 + 50 * random(), 'p': 2000 * random(),
                 'k': 2000 * random(), 'n': 2000 * random(), 'temp': 20 + 10 * random(), 'ph': 5 + 3 * random()},
                {'longitude': 29.993, 'latitude': 40.0085, 'moisture': 50 + 50 * random(), 'p': 2000 * random(),
                 'k': 2000 * random(), 'n': 2000 * random(), 'temp': 20 + 10 * random(), 'ph': 5 + 3 * random()}, ]

    for sensor in sensors1:
        FarmReport.objects.create(farm_id=farm_id1, moisture=sensor['moisture'], phosphorus=sensor['p'],
                                  potassium=sensor['k'], nitrogen=sensor['n'], temperature=sensor['temp'],
                                  ph=sensor['ph'], latitude=sensor['latitude'], longitude=sensor['longitude'],
                                  date_collected=timezone.now())

        FarmReportLog.objects.create(farm_id=farm_id1, moisture=sensor['moisture'], phosphorus=sensor['p'],
                                     potassium=sensor['k'], nitrogen=sensor['n'], temperature=sensor['temp'],
                                     ph=sensor['ph'], latitude=sensor['latitude'], longitude=sensor['longitude'],
                                     date_collected=timezone.now())

    calendar_event_create(users[0], farm_id=farm_id1)
    worker_activity_create(farm_id=farm_id1)
    # 2ND FARM
    farm2 = Farm.objects.create(name='pattes', area=1, owner=users[0])
    farm_id2 = farm2.id

    hexagon_points = [
        (1, 0),
        (0.866, 0.5),
        (0.5, 0.866),
        (0, 1),
        (-0.5, 0.866),
        (-0.866, 0.5)]
    sensor_locations = [
        (0.3, 0.4),
        (-0.2, 0.6),
        (0.5, -0.2),
        (-0.4, -0.3),
        (0.1, -0.1)]

    farm_corners2 = [[32 + i[1] * 0.001, 40 + i[0] * 0.001] for i in hexagon_points]

    for farm in farm_corners2:
        FarmCornerPoint.objects.create(farm_id=farm_id2, latitude=farm[1], longitude=farm[0])

    sensors2 = []
    for sensor_location in sensor_locations:
        sensors2.append({'longitude': 32 + sensor_location[0] * 0.001, 'latitude': 40 + sensor_location[1] * 0.001,
                         'moisture': 50 + 50 * random(), 'p': 2000 * random(), 'k': 2000 * random(),
                         'n': 2000 * random(), 'temp': 20 + 10 * random(), 'ph': 5 + 3 * random()})

    for sensor in sensors2:
        FarmReport.objects.create(farm_id=farm_id2, moisture=sensor['moisture'], phosphorus=sensor['p'],
                                  potassium=sensor['k'], nitrogen=sensor['n'], temperature=sensor['temp'],
                                  ph=sensor['ph'], latitude=sensor['latitude'], longitude=sensor['longitude'],
                                  date_collected=timezone.now())

        FarmReportLog.objects.create(farm_id=farm_id2, moisture=sensor['moisture'], phosphorus=sensor['p'],
                                     potassium=sensor['k'], nitrogen=sensor['n'], temperature=sensor['temp'],
                                     ph=sensor['ph'], latitude=sensor['latitude'], longitude=sensor['longitude'],
                                     date_collected=timezone.now())
    calendar_event_create(users[0], farm_id=farm_id2)
    worker_activity_create(farm_id=farm_id2)


def create_posts():
    Reply.objects.all().delete()
    Post.objects.all().delete()

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
            random_username = choice(usernames)
            message = messages[filename.split('.')[0]]
            Post.objects.create(message=message, image=image, username=random_username)
            Reply.objects.create(message=replies[filename.split('.')[0]], username=choice(usernames),
                                 post_id=Post.objects.last().id)


class Command(BaseCommand):
    def handle(self, *args, **kwargs):
        delete_users()
        create_users()
        farm_create()
        create_posts()

