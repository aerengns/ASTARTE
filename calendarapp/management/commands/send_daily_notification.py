import random

from django.contrib.auth.models import User
from django.core.management.base import BaseCommand

from backendcore.utils.core_utils import send_notification
from calendarapp.management.commands.notifications import MOTIVATIONAL_MESSAGES


class Command(BaseCommand):

    def handle(self, *args, **kwargs):
        # Get one farm for all users, send related weather notification

        for user in User.objects.filter(is_active=True)[:3]:
            context = {'title': 'Daily reminder', 'body': random.choice(MOTIVATIONAL_MESSAGES)}
            try:
                send_notification(user.profile, context)
            except Exception:
                print(f"Could not send notification to user with id {user.id}")
                pass
