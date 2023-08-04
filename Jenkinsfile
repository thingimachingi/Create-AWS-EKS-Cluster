
	
	
pipeline {    
    agent any
    
    stages {
        stage("Test") {
		def userInput = input(id: 'userInput', message: 'some message', parameters: [
			[$class: 'ChoiceParameterDefinition', choices: string, description: 'description1', name:'input1'],
			[$class: 'ChoiceParameterDefinition', choices: string, description: 'description2', name:'input2'],
			])
    VARAIBLE1 = userInput['input1']
    VARAIBLE2 = userInput['input2']

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