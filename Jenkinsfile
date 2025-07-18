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
                      set -e  # Exit immediately if a command fails

                      cd ~

                      # Clone or refresh repo
                      rm -rf flask-app
                      git clone https://github.com/panthangiEshwary/flask-jenkins-cicd.git flask-app
                      cd flask-app

                      # Set up Python virtual environment
                      if [ ! -d "venv" ]; then
                        python3 -m venv venv
                      fi
                      source venv/bin/activate

                      # Install Python dependencies
                      pip install --break-system-packages -r requirements.txt

                      # Kill any process using port 5000
                      PID=$(lsof -t -i:5000)
                      if [ -n "$PID" ]; then
                        echo "Killing process on port 5000 (PID: $PID)"
                        kill -9 $PID
                      fi

                      # Start Gunicorn
                      nohup venv/bin/gunicorn --bind 0.0.0.0:5000 app:app &

                      echo "Gunicorn started on port 5000"
                    EOF
                    '''
                }
            }
        }
    }
}
