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
                      set -ex  # Enable debug output and stop on error

                      echo "🧼 Cleaning existing app folder"
                      cd ~
                      rm -rf flask-app

                      echo "📦 Cloning repository"
                      git clone https://github.com/panthangiEshwary/flask-jenkins-cicd.git flask-app
                      cd flask-app

                      echo "🐍 Creating virtual environment"
                      if [ ! -d "venv" ]; then
                        python3 -m venv venv
                      fi
                      source venv/bin/activate

                      echo "📦 Installing dependencies"
                      pip install --break-system-packages -r requirements.txt

                      echo "🔍 Checking for process on port 5000"
                      PID=$(lsof -t -i:5000 || true)
                      if [ -n "$PID" ]; then
                        echo "⚠️ Killing existing process on port 5000 (PID: $PID)"
                        kill -9 $PID
                      fi

                      echo "🚀 Starting Gunicorn"
                      nohup venv/bin/gunicorn --bind 0.0.0.0:5000 app:app > gunicorn.log 2>&1 &

                      sleep 5
                      if lsof -i:5000; then
                        echo "✅ Gunicorn is running on port 5000"
                      else
                        echo "❌ Gunicorn failed to start"
                        cat gunicorn.log
                        exit 1
                      fi
                    EOF
                    '''
                }
            }
        }
    }
}
