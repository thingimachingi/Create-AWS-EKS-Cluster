
	
	
pipeline {    
    agent any
    
    stages {
        stage("Test") {

            steps {
				script {
				  env.DESTROY_EKS_CLUSTER = input message: 'Want to destroy the EKS cluster',
									 parameters: [string(defaultValue: 'No',
												  description: 'Say Yes or No',
												  name: 'DestroyEksCluster')]
				}
				echo "DESTROY_EKS_CLUSTER: ${env.DESTROY_EKS_CLUSTER}"
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
					
					script {
						if (env.DESTROY_EKS_CLUSTER == 'Yes') {
							echo "Going to destroy EKS Cluster"
							sh "terraform destroy -auto-approve"
						} else {
							echo "Going to create EKS Cluster"
							input 'Want to create the EKS Cluster?'
							//TODO: execute the below two steps only if the cluster already does not exist
							sh "terraform init"
							sh "terraform apply -auto-approve"
							//TODO: add verify cluster steps. refer to https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks
						}
					}
					
					
                }
            }
        }
    }
    

}    