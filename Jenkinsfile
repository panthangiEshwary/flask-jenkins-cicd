pipeline {
    agent any

    stages {
        stage('Deploy to EC2') {
            steps {
                sshagent(['flask-ec2-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@52.23.252.187 << EOF
                        echo "🔁 Pulling latest code"
                        rm -rf ~/flask-app
                        git clone https://github.com/panthangiEshwary/flask-jenkins-cicd.git ~/flask-app
                        cd ~/flask-app

                        echo "🐍 Creating virtual environment"
                        python3 -m venv venv
                        source venv/bin/activate
                        pip install --break-system-packages -r requirements.txt

                        echo "🛑 Killing existing Gunicorn process (port 5000)"
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
