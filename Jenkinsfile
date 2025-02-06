pipeline {
    agent any



    stages {
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
                                    sourceFiles: '',
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
