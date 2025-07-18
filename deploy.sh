#!/bin/bash

APP_DIR=~/flask-app

# Clone if not exists
if [ ! -d "$APP_DIR" ]; then
    git clone https://github.com/YOUR_USERNAME/flask-jenkins-cicd.git $APP_DIR
fi

cd $APP_DIR
source venv/bin/activate
git pull origin main
pip install -r requirements.txt

# Kill any existing Gunicorn process
pkill -f gunicorn || true

# Run Flask app using Gunicorn
nohup gunicorn --bind 0.0.0.0:5000 app:app > flask.log 2>&1 &

