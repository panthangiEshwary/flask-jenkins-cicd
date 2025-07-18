pipeline {
    agent any

    environment {
        EC2_HOST = "ubuntu@52.23.252.187"
        APP_DIR = "/home/ubuntu/flask-app"
        GIT_REPO = "https://github.com/panthangiEshwary/flask-jenkins-cicd.git"
    }

    stages {
        stage('Deploy Flask App to EC2') {
            steps {
                sshagent(credentials: ['flask-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no $EC2_HOST << EOF
                      echo "🔁 Pulling latest code"
                      rm -rf $APP_DIR
                      git clone $GIT_REPO $APP_DIR
                      cd $APP_DIR

                      echo "🐍 Setting up virtual environment"
                      python3 -m venv venv
                      source venv/bin/activate
                      pip install --break-system-packages -r requirements.txt

                      echo "🛑 Killing existing Gunicorn process on port 5000 (if any)"
                      PID=$(lsof -t -i:5000)
                      if [ -n "$PID" ]; then
                          kill -9 $PID
                      fi

                      echo "🚀 Starting Gunicorn"
                      nohup venv/bin/gunicorn --bind 0.0.0.0:5000 app:app > gunicorn.log 2>&1 &
                    EOF
                    '''
                }
            }
        }
    }
}
