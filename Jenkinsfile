pipeline {
    agent any



    stages {

        stage('installing docker and docker-compose on ubuntu-server') {
            steps {
                script {
                    // Check if Docker is already installed
                    def dockerInstalled = sh(script: 'which docker', returnStatus: true) == 0
                    if (!dockerInstalled) {
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
                                        execCommand: '''
                                            sudo apt-get update
                                            sudo apt-get install -y docker.io
                                            sudo apt-get install -y docker-compose
                                            sudo systemctl start docker
                                            sudo systemctl enable docker
                                        '''
                                    )
                                ],
                                usePromotionTimestamp: false,
                                verbose: true
                            )
                        ])
                    } else {
                        echo 'Docker is already installed.'
                    }
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
