pipeline {
    agent any

    environment {
        SSH_SERVER = 'ubuntu_server'  // Use Jenkins configured SSH Server (No public IP in pipeline)
        JENKINS_SERVER_HOST = '44.223.29.76'  // Public IP of EC2 instance
    }

    stages {
        stage('Install Docker on EC2') {
            steps {
            withCredentials([sshUserPrivateKey(credentialsId: 'ec2_access_key', keyFileVariable: 'SSH_KEY')]) {
                sh '''
                ssh -i $SSH_KEY -o StrictHostKeyChecking=no ubuntu@${JENKINS_SERVER_HOST} <<EOF 
                   
                if which docker > /dev/null 2>&1 && which docker-compose > /dev/null 2>&1; then 
                    echo "Both docker and docker-compose are installed"
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

        stage('Deploy Docker Containers') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2_access_key', keyFileVariable: 'SSH_KEY')]) {
                    sh ''' 
                        ssh -i $SSH_KEY -o StrictHostKeyChecking=no ubuntu@${JENKINS_SERVER_HOST} <<EOF
                        rm -f docker-compose.yaml
                        EOF
                        scp -i $SSH_KEY -o StrictHostKeyChecking=no docker-compose.yaml ubuntu@${JENKINS_SERVER_HOST}:/home/ubuntu/
                        
                        ssh -i $SSH_KEY -o StrictHostKeyChecking=no ubuntu@${JENKINS_SERVER_HOST} <<EOF
                        docker-compose down
                        docker-compose up -d
                        EOF
                    '''
                }
            }
        }
    }
}
