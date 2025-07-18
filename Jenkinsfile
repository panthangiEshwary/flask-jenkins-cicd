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
                      cd ~
                      rm -rf flask-app
                      git clone https://github.com/panthangiEshwary/flask-jenkins-cicd.git flask-app
                      cd flask-app

                      [ ! -d venv ] && python3 -m venv venv
                      source venv/bin/activate

                      pip install --upgrade pip
                      pip install --break-system-packages -r requirements.txt

                      # Kill process using port 5000
                      fuser -k 5000/tcp || echo "Port 5000 already free"

                      # Start Gunicorn in background
                      nohup venv/bin/gunicorn --bind 0.0.0.0:5000 app:app &
                      echo "Flask App Deployed on EC2"
                    EOF
                    '''
                }
            }
        }
    }
}
