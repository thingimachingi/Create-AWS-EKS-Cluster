
pipeline {    
    agent any
    
    stages {
        stage("Test") {
            steps {
                println (WORKSPACE)
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'ThingiMachingiGitHubCred', url: 'https://github.com/thingimachingi/Create-AWS-EKS-Cluster']])
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "mkrish2-accessid-secret",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    // AWS Code
                    sh "aws sts get-caller-identity"
					sh "terraform init"
					sh "terraform apply -auto-approve"
                }
            }
        }
    }
    

}    