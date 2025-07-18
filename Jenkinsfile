pipeline {
    agent any

    stages {
        stage('Deploy to EC2') {
            steps {
                sshagent(['flask-ec2-key']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@52.23.252.187 << 'EOF'
                            cd ~
                            rm -rf flask-app
                            git clone https://github.com/panthangiEshwary/flask-jenkins-cicd.git flask-app
                            cd flask-app

                            if [ ! -d "venv" ]; then
                                python3 -m venv venv
                            fi

                            source venv/bin/activate
                            pip install --break-system-packages -r requirements.txt

                            fuser -k 5000/tcp || true

                            nohup venv/bin/gunicorn --bind 0.0.0.0:5000 app:app &
                        EOF
                    '''
                }
            }
        }
    }
}
