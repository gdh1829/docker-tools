#!/bin/sh
set -ex
echo $PWD
echo $ENV
if [ "${ENV}" == "PROD" ]; then
	echo "Running Production Server"
	exec uwsgi --http 0.0.0.0:9090 --wsgi-file /usr/src/app/identidock.py --callable app --stats 0.0.0.0:9191
elif [ "${ENV}" == "UT" ]; then
	echo "Running Unit Test"
	exec python3 "tests.py"
else
	echo "Running Development Server"
	exec python3 "identidock.py"
fi
