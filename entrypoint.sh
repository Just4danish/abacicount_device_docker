#!/bin/bash
python manage.py migrate
celery -A abaci_count_main worker -l INFO&
daphne -b 0.0.0.0 -p 8500 abaci_count_main.asgi:application
