pipeline {
    agent any

    environment {
        JENKINS_SERVER_HOST = '3.87.78.9'
    }

    stages {
        stage('Install Docker on EC2') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ec2_access_key', keyFileVariable: 'SSH_KEY')]) {
                        sh '''
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
                        '''
                    }
                }
            }
        }

        stage('Deploy Docker Containers') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ec2_access_key', keyFileVariable: 'SSH_KEY')]) {
                        sh '''
                        ssh -i $SSH_KEY -o StrictHostKeyChecking=no ubuntu@$JENKINS_SERVER_HOST << 'EOF'
                        rm -f docker-compose.yaml
                        EOF

                        scp -i $SSH_KEY -o StrictHostKeyChecking=no docker-compose.yaml ubuntu@$JENKINS_SERVER_HOST:/home/ubuntu/

                        ssh -i $SSH_KEY -o StrictHostKeyChecking=no ubuntu@$JENKINS_SERVER_HOST << 'EOF'
                        docker-compose down
                        docker-compose up -d
                        EOF
                        '''
                    }
                }
            }
        }
    }
}
