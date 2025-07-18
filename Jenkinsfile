pipeline {
    agent any

    stages {
        stage('Pull Code') {
            steps {
                git branch: 'main', url: 'https://github.com/your-username/your-flask-repo.git'
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['your-ssh-credential-id']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@<EC2-PUBLIC-IP> << EOF
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

