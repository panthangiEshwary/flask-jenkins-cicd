pipeline {
    agent any

    stages {
        stage('Pull Code') {
            steps {
                git branch: 'main', url: 'https://github.com/panthangiEshwary/flask-jenkins-cicd.git'
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['flask-ec2-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@<YOUR_EC2_PUBLIC_IP> << 'EOF'
                      set -e
                      cd ~

                      # Clean old code and clone latest
                      rm -rf flask-app
                      git clone https://github.com/panthangiEshwary/flask-jenkins-cicd.git flask-app
                      cd flask-app

                      # Create virtual env if not exists
                      [ ! -d venv ] && python3 -m venv venv
                      source venv/bin/activate

                      # Install dependencies
                      pip install --upgrade pip
                      pip install --break-system-packages -r requirements.txt

                      # Kill app if running
                      PID=$(lsof -t -i:5000) && [ -n "$PID" ] && kill -9 $PID || echo "No existing process"

                      # Start app
                      nohup venv/bin/gunicorn --bind 0.0.0.0:5000 app:app &

                      echo "App Deployed Successfully"
                    EOF
                    '''
