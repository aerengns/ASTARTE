import requests
from django.contrib.auth.models import User
from django.core.management.base import BaseCommand

from backendcore.models import Farm
from backendcore.utils.core_utils import send_notification
from calendarapp.management.commands.notifications import weather_code_mapping


class Command(BaseCommand):

    def handle(self, *args, **kwargs):
        # Get one farm for all users, send related weather notification
        farms = Farm.objects.filter(is_active=True)

        farm_weather_code_dict, user_ids = self.get_related_weather_codes_from_farms(farms)

        user_dict = {user.id: user.profile for user in User.objects.filter(id__in=user_ids)}

        for key, code in farm_weather_code_dict.items():
            user_id, farm_name = key.split('|')
            send_notification(user_dict[int(user_id)], weather_code_mapping[code])  # TODO: add farm_name

    def get_related_weather_codes_from_farms(self, farms):
        WEATHER_API_URL = 'https://api.open-meteo.com/v1/forecast'

        farm_weather_code_dict = {}
        user_ids = set()

        for farm in farms:
            corner = farm.farmcornerpoint_set.first()

            response = requests.get(f"{WEATHER_API_URL}"
                                    f"?latitude={corner.latitude}"
                                    f"&longitude={corner.longitude}"
                                    f"&current_weather=true")

            if response.status_code == 200:
                data = response.json()
                user_ids.add(farm.owner.id)
                farm_weather_code_dict[f"{farm.owner.id}|{farm.name}"] = data['current_weather']['weathercode']

        farm_weather_code_dict_only_with_values = {k: v for k, v in farm_weather_code_dict.items() if v is not None}

        return farm_weather_code_dict_only_with_values, user_ids
