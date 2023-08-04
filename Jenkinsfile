
	
	
pipeline {    
    agent any
    
    stages {
        stage("Test") {

            steps {
				script {
				  env.USERNAME = input message: 'Please enter the username',
									 parameters: [string(defaultValue: '',
												  description: '',
												  name: 'Username')]
				  env.PASSWORD = input message: 'Please enter the password',
									 parameters: [password(defaultValue: '',
												  description: '',
												  name: 'Password')]
			}
			echo "Username: ${env.USERNAME}"
			echo "Password: ${env.PASSWORD}"
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
					
					
					
					input 'Want to destroy the EKS cluster2?'
					//TODO: execute the below two steps only if the cluster already does not exist
					sh "terraform init"
					sh "terraform apply -auto-approve"
					//TODO: add verify cluster steps. refer to https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks
                }
            }
        }
    }
    

}    