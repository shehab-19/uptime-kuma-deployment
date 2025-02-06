pipeline {
    agent any



    stages {

        stage('installing docker and docker-compose') {
            steps {
                script {
                    sh '''
                        sudo apt-get update
                        sudo apt-get install -y docker.io
                        sudo apt-get install -y docker-compose
                        sudo systemctl start docker
                        sudo systemctl enable docker
                        docker --version
                        docker-compose --version
                    '''
                }
            }
        }


        stage('Deployment') {
            steps {
                script{
                    // First SSH Publisher step
                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: 'ubuntu_server', 
                            transfers: [
                                sshTransfer(
                                    cleanRemote: false, 
                                    excludes: '',  
                                    execTimeout: 120000, 
                                    flatten: false, 
                                    makeEmptyDirs: false, 
                                    noDefaultExcludes: false, 
                                    patternSeparator: '[, ]+', 
                                    remoteDirectory: '', 
                                    remoteDirectorySDF: false, 
                                    removePrefix: '',
                                    // sourceFiles: 'shehab.py',
                                    execCommand: 'docker-compose down && rm docker-compose.yaml'
                                )
                            ],
                            usePromotionTimestamp: false,
                            verbose: true
                        )
                    ])

                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: 'ubuntu_server', 
                            transfers: [
                                sshTransfer(
                                    cleanRemote: false, 
                                    excludes: '',  
                                    execTimeout: 120000, 
                                    flatten: false, 
                                    makeEmptyDirs: false, 
                                    noDefaultExcludes: false, 
                                    patternSeparator: '[, ]+', 
                                    remoteDirectory: '', 
                                    remoteDirectorySDF: false, 
                                    removePrefix: '',
                                    execCommand: 'docker-compose up -d',
                                    sourceFiles: 'docker-compose.yaml'
                                )
                            ],
                            usePromotionTimestamp: false,
                            verbose: true
                        )
                    ])
                }    
            }
        }
    }
}
