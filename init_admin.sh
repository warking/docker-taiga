#!/bin/sh 

docker exec taiga-back python manage.py loaddata initial_user
docker exec taiga-back python manage.py loaddata initial_project_templates

exit 0
