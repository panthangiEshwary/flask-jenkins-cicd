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
                sshagent(['ubuntu']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@52.23.252.187 << EOF
                      cd ~
                      rm -rf flask-app
                      git clone https://github.com/panthangiEshwary/flask-jenkins-cicd.git flask-app
                      cd flask-app
                      python3 -m venv venv
                      source venv/bin/activate
                      pip install --break-system-packages -r requirements.txt
                      pkill gunicorn || true
                      nohup venv/bin/gunicorn --bind 0.0.0.0:5000 app:app &
                    EOF
                    '''
                }
            }
        }
    }
}

