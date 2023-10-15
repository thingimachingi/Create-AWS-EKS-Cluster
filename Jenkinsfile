
	
	
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
				script {
				  env.DEPLOY_CLOVER_LOGGING = input message: 'Want to deploy clover logging on the EKS cluster',
									 parameters: [string(defaultValue: 'No',
												  description: 'Say Yes or No',
												  name: 'DeployCloverLogging')]
				}

				script {
				  env.CREATE_INGRESS_CONTROLLER = input message: 'Want to create the Ingress Controller/ALB for EKS service',
									 parameters: [string(defaultValue: 'No',
												  description: 'Say Yes or No',
												  name: 'CreateIngressController')]
				}

                println (WORKSPACE)
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'ThingiMachingiGitHubCred', url: 'https://github.com/thingimachingi/Create-AWS-EKS-Cluster']])
				
                withCredentials([
					[
						$class: 'AmazonWebServicesCredentialsBinding',
						credentialsId: "mkrish2-accessid-secret",
						accessKeyVariable: 'AWS_ACCESS_KEY_ID',
						secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
					],
					[
						$class: 'UsernamePasswordMultiBinding', 
						credentialsId:'DockerCred', 
						usernameVariable: 'USERNAME', 
						passwordVariable: 'PASSWORD'
					]
				
				]) {
				
                    // AWS Code
                    //sh "aws sts get-caller-identity"
					
					script {
						if (env.CREATE_INGRESS_CONTROLLER== 'Yes') {
							sh 'aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)'
							sh 'kubectl cluster-info'
							//sh 'kubectl create ns clover-dev'
							echo "Created namespace clover-dev in EKS Cluster"
							sh "terraform init"
							sh "terraform apply -auto-approve"
	
							//sh 'kubectl apply -f clover-logging-deployment.yml'
							//sh 'kubectl apply -f clover-logging-ingress.yml'
							
							//sh 'kubectl patch deployment clover-logging-deployment -n clover-dev -p \'{"spec":{"template":{"spec":{"containers":[{"name":"clover-logging","image":"mkrish2/clover-logging:healthcheck"}]}}}}\''
							sh 'kubectl get deployment -n clover-dev clover-logging-deployment'
							sh 'kubectl get deployment -n clover-dev kubernetes_deployment'
							
						}
						else if (env.DEPLOY_CLOVER_LOGGING == 'Yes') {
							echo "Going to deploy clover-logging on EKS Cluster"
							//important to connect to the cluster and issue further commands
							sh 'aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)'
							sh 'kubectl cluster-info'
							//sh 'kubectl create ns clover-dev'
							sh 'kubectl create secret docker-registry dockerhub-cred --docker-server=https://index.docker.io/v1/ --docker-username=$USERNAME --docker-password=$PASSWORD --docker-email=mkrish2@gmail.com --namespace=clover-dev'
							sh 'kubectl get secrets dockerhub-cred --namespace=clover-dev'
							sh 'kubectl apply -f create-service-account.yml'
							sh 'kubectl get sa clover-sa --namespace=clover-dev'
							sh 'kubectl apply -f clover-logging-deployment.yml'
							sh 'kubectl expose deployment clover-logging-deployment --namespace=clover-dev --type=LoadBalancer --name=clover-logging-service'
							sh 'kubectl get service/clover-logging-service --namespace=clover-dev'
							sh 'kubectl get services -n clover-dev -o wide'
						}
						else if (env.DESTROY_EKS_CLUSTER == 'Yes') {
							//important to connect to the cluster and issue further commands
							sh 'aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)'
							sh 'kubectl cluster-info'
						
							echo "Going to destroy EKS Cluster"
							sh 'kubectl -n clover-dev delete pod,svc --all'
							sh "terraform destroy -auto-approve"
						} else {
							echo "Going to create EKS Cluster"
							input 'Want to create the EKS Cluster?'
							//TODO: execute the below two steps only if the cluster already does not exist
							sh "terraform init"
							sh "terraform apply -auto-approve"
							//important to connect to the cluster and issue further commands
							sh 'aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)'
							sh 'kubectl cluster-info'
							sh 'kubectl create ns clover-dev'
							echo "Created namespace clover-dev in EKS Cluster"
							//TODO: add verify cluster steps. refer to https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks
						}
					}
					
					
                }
            }
        }
    }
    

}    