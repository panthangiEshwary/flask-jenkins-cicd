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
                      cd ~/flask-app
                      git pull
                      source venv/bin/activate
                      pip install -r requirements.txt
                      pkill gunicorn || true
                      nohup gunicorn --bind 0.0.0.0:5000 app:app &
                    EOF
                    '''
                }
            }
        }
    }
}

