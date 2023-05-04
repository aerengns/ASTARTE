import random
import string

from django.core.management import BaseCommand

from workers.models import Worker


class Command(BaseCommand):
    @staticmethod
    def random_string(length):
        letters = string.ascii_letters
        return ''.join(random.choice(letters) for i in range(length))

    def handle(self, **kwargs):
        Worker.objects.all().delete()
        prefab = [{'name': 'Jasmine', 'surname': 'Smith', 'email': 'jasmine.smith@example.com',
                   'about': 'Voluptatem et eveniet libero ut voluptatem voluptatem molestiae. Dolore vel autem expedita dolorum fugit qui. Autem et aut quo qui. Cum quo sit nobis repudiandae.'},
                  {'name': 'Oliver', 'surname': 'Davis', 'email': 'oliver.davis@example.com',
                   'about': 'Quae veniam molestias id vel dolor. Eos cum debitis neque ut nobis. Commodi ad rerum debitis et. Qui rerum tenetur explicabo fuga.'},
                  {'name': 'Caroline', 'surname': 'Hill', 'email': 'caroline.hill@example.com',
                   'about': 'In quia id saepe est dignissimos magnam eum non. Qui cupiditate et repellendus asperiores qui iusto dolore. Et velit aut veniam voluptatum est ea eveniet.'},
                  {'name': 'Max', 'surname': 'Walker', 'email': 'max.walker@example.com',
                   'about': 'Sed aut dolorem voluptatem et voluptatem omnis laboriosam. Mollitia repellat sunt minima laudantium nam recusandae. Non veniam et cupiditate laborum. Voluptatem vel nemo quos dolor.'},
                  {'name': 'Catherine', 'surname': 'Gonzalez', 'email': 'catherine.gonzalez@example.com',
                   'about': 'Nihil ipsam ab incidunt quae id omnis saepe. Aut dolor dolorem non tempora. Quo autem et aliquid quae. Aliquid maxime nulla recusandae rem.'},
                  {'name': 'Isabella', 'surname': 'Rodriguez', 'email': 'isabella.rodriguez@example.com',
                   'about': 'Quasi dolor aut omnis molestiae repellendus ea dolorem. Ut id aut est quia. Nemo atque sequi qui explicabo odit voluptas. Qui natus maxime dolorem et rem quidem sint.'},
                  {'name': 'Jacob', 'surname': 'Anderson', 'email': 'jacob.anderson@example.com',
                   'about': 'Sed est id eveniet voluptate cupiditate molestiae dolorem. Ut sit error non non. Et distinctio in quo. Laboriosam aut occaecati asperiores et necessitatibus.'},
                  {'name': 'Liam', 'surname': 'Wright', 'email': 'liam.wright@example.com',
                   'about': 'Rem recusandae autem aliquid sed. Sit sint qui aut voluptas enim recusandae. Consequatur et quia ut perspiciatis maxime earum. Ex aliquid dignissimos fugiat sit sint ut.'},
                  {'name': 'Sophie', 'surname': 'Campbell', 'email': 'sophie.campbell@example.com',
                   'about': 'Aut asperiores sunt voluptas consectetur enim. Nisi quisquam a laborum fugit quisquam. Eius similique quis omnis consequatur. Ratione aut nihil quia.'},
                  {'name': 'Henry', 'surname': 'Parker', 'email': 'henry.parker@example.com',
                   'about': 'Deleniti minima quos incidunt consectetur. Necessitatibus id nam reprehenderit est. Qui molestiae nulla ut earum. Quae doloribus ut velit numquam ut numquam.'}]

        worker_list = []
        for args in prefab:
            worker_list.append(Worker(
                **args
            ))
        Worker.objects.bulk_create(worker_list)
