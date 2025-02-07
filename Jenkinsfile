pipeline {
    agent any

    environment {
        SSH_SERVER = 'ubuntu_server'  // Use Jenkins configured SSH Server
    }

    stages {
        stage('Install Docker on EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2_access_key', keyFileVariable: 'SSH_KEY')]) {
                    sshPublisher(
                        publishers: [
                            sshPublisherDesc(
                                configName: SSH_SERVER,
                                transfers: [],
                                execCommand: '''
                                    if which docker > /dev/null 2>&1 && which docker-compose > /dev/null 2>&1; then 
                                        echo "Both docker and docker-compose are installed"
                                    else
                                        echo "Installing Docker and Docker Compose"
                                        sudo apt-get update
                                        sudo apt-get install -y docker.io docker-compose
                                        sudo systemctl start docker
                                        sudo systemctl enable docker
                                    fi
                                '''
                            )
                        ]
                    )
                }
            }
        }

        stage('Deploy Docker Containers') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2_access_key', keyFileVariable: 'SSH_KEY')]) {
                    sshPublisher(
                        publishers: [
                            sshPublisherDesc(
                                configName: SSH_SERVER,
                                transfers: [
                                    sshTransfer(
                                        sourceFiles: 'docker-compose.yaml',
                                        remoteDirectory: '/home/ubuntu/',
                                        removePrefix: '',
                                        execCommand: '''
                                            docker-compose down
                                            docker-compose up -d
                                        '''
                                    )
                                ]
                            )
                        ]
                    )
                }
            }
        }
    }
}
