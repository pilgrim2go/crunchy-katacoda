#!/usr/bin/bash

echo 'please wait while we prep the environment (should take about 10 seconds)'
echo 'starting the database'
docker network create mybridge

docker run -d --network mybridge -p 5050:5050 -e PGADMIN_SETUP_EMAIL=admin -e PGADMIN_SETUP_PASSWORD=password --name=pgadmin crunchydata/crunchy-pgadmin4:centos7-12.2-4.3.0

docker run -d --network mybridge -p 5432:5432 -e PG_USER=groot -e PG_PASSWORD=password -e PG_DATABASE=workshop --name=pgsql crunchydata/crunchy-postgres-appdev

until PGPASSWORD="password" psql -h localhost -U groot postgres -c '\l' &> /dev/null; do
  echo >&2 "$(date +%Y%m%dt%H%M%S) Waiting for Postgres to start"
  sleep 1
done

PGPASSWORD="password" psql -h localhost -U groot workshop