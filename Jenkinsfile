pipeline{
    agent any
    tools{
        maven 'Maven Default'
    }
    stages{
        stage('Checkout Project'){
            steps{
                checkout scmGit(branches: [[name: '*/test1']],
                //extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'TerraformLab']],
                userRemoteConfigs: [[credentialsId: 'DevOpsGitHub', url: 'https://github.com/josemcortesh/InsuranceManagement.git']])
            }
        }
        stage('Terraform Init'){
            steps{
                script{
                    sh 'terraform -chdir=./TerraformInfra init'
                }
            }    
        }
        stage('Terraform Plan'){
            steps{
                script{
                    withAWS(credentials: 'DevOpsLabs', region: 'us-east-1') {
                        sh 'terraform -chdir=./TerraformInfra plan -var-file="ansiblelab.tfvars"'
                    }
                }
            }
        }
        stage('Terraform Apply'){
            steps{
                script{
                    withAWS(credentials: 'DevOpsLabs', region: 'us-east-1'){
                        sh 'terraform -chdir=./TerraformInfra apply -var-file="ansiblelab.tfvars" -auto-approve'
                    }
                }    
            }
        }
        stage('Code Validation'){
            steps{
                sh 'mvn -V -f Code/pom.xml validate | tee ./Code/Logs/validation.log'
                sh 'echo "The code validation has been completed"'
                sh 'echo "The output has been collected in the workspace under path Code/Logs/validation.log"'
            }
        }
        stage('Code Compilation'){
            steps{
                sh 'mvn -V -f Code/pom.xml compile | tee ./Code/Logs/compilation.log'
                sh 'echo "The code compilation has been completed"'
                sh 'echo "The output has been collected in the workspace under path Code/Logs/compilation.log"'
            }
        }
        stage('Code Testing'){
            steps{
                sh 'mvn -V -f Code/pom.xml test | tee ./Code/Logs/tests.log'
                sh 'echo "The code testing has been completed"'
                sh 'echo "The output has been collected in the workspace under path Code/Logs/tests.log"'
            }
        }
        stage('Code Packaging'){
            steps{
                sh 'mvn -V -f Code/pom.xml package | tee ./Code/Logs/package.log'
                sh 'echo "The code packaging has been completed"'
                sh 'echo "The output has been collected in the workspace under path Code/Logs/package.log"'
            }
        }
        stage('Build and Push Docker image'){
            steps{
                script{
                    docker.withRegistry('','Dockerhub'){
                        def NewImage = docker.build("josemcortesh/insure-me:${env.BUILD_ID}")
                        NewImage.push()
                        NewImage.push('latest')
                    }
                }
            }
        }
        stage('Deploy Ansible Playbook'){
            steps{
                script{
                    // Change to the directory where the ansible playbooks are located.
                    dir('./AnsiblePlaybooks') {
                        withAWS(credentials: 'DevOpsLabs') {
                            ansiblePlaybook credentialsId: 'AnsibleLabUser', installation: 'Ansible-Local', inventory: 'ansiworkers.aws_ec2.yml', playbook: 'DockerCleanUp-Playbook.yml'
                            sh 'echo "this line confirms thea the second playbook has been executed"'
                            
                            ansiblePlaybook credentialsId: 'AnsibleLabUser', installation: 'Ansible-Local', inventory: 'ansiworkers.aws_ec2.yml', playbook: 'DeployOnDocker-Playbook.yml'
                            sh 'echo "This line confirms that the third playbook has been executed"'
                        }    
                    }
                }
            }
        }
    }
}
