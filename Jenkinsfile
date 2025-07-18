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
ssh -o StrictHostKeyChecking=no ubuntu@52.23.252.187 << 'EOF'
  set -e
  echo "Killing existing gunicorn processes"
  pkill -f gunicorn || echo "No gunicorn process running"

  echo "Cloning latest code"
  cd ~
  rm -rf flask-app
  git clone https://github.com/panthangiEshwary/flask-jenkins-cicd.git flask-app
  cd flask-app

  echo "Setting up virtual environment"
  [ ! -d venv ] && python3 -m venv venv
  source venv/bin/activate

  pip install --upgrade pip
  pip install --break-system-packages -r requirements.txt

  echo "Starting Flask app"
  nohup venv/bin/gunicorn --bind 0.0.0.0:5000 app:app > app.log 2>&1 &

  echo "Flask App Deployed on EC2"
EOF
                    '''
                }
            }
        }
    }
}
