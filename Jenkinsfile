pipeline {
    agent any

    environment {
        JENKINS_SERVER_HOST = '54.198.141.234'
    }

    stages {
        stage('Install Docker on EC2') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ec2_access_key', keyFileVariable: 'SSH_KEY')]) {
                        sh """
                        ssh -i $SSH_KEY -o StrictHostKeyChecking=no ubuntu@$JENKINS_SERVER_HOST << 'EOF'
                        if which docker > /dev/null 2>&1 && which docker-compose > /dev/null 2>&1; then 
                            echo "Both Docker and Docker Compose are installed"
                        else
                            echo "Installing Docker and Docker Compose"
                            sudo apt-get update
                            sudo apt-get install -y docker.io docker-compose
                            sudo systemctl start docker
                            sudo systemctl enable docker
                        fi                       
                        EOF
                        """
                    }
                }
            }
        }


        stage('copy docker-compose.yaml to EC2') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ec2_access_key', keyFileVariable: 'SSH_KEY')]) {
                        sh """
                        scp -i $SSH_KEY -o StrictHostKeyChecking=no docker-compose.yaml ubuntu@$JENKINS_SERVER_HOST:/home/ubuntu/
                        """
                    }
                }
            }
        }


        stage('Deploy Docker Containers') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ec2_access_key', keyFileVariable: 'SSH_KEY')]) {
                        sh """
                        chmod 600 $SSH_KEY
                        ssh -i $SSH_KEY -o StrictHostKeyChecking=no ubuntu@$JENKINS_SERVER_HOST << 'EOF'
                        ls -l
                         if [ -f "docker-compose.yaml" ]; then
                             docker-compose down
                             rm docker-compose.yaml
                         fi
                        docker-compose up -d
                        EOF
                        """
                    }
                }
            }
        }
    }
}
