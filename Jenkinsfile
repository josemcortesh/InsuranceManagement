pipeline{
    agent any
    stages{
        stage('Checkout files'){
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
                        sh 'terraform -chdir=./TerraformInfra destroy -var-file="ansiblelab.tfvars" -auto-approve'
                    }
                }    
            }
        }
//        stage('Checkout Ansible Playbooks'){
//            steps{
//               checkout scmGit(branches: [[name: '*/main']],
//                extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'AnsiblePlaybooks']],
//                userRemoteConfigs: [[credentialsId: 'DevOpsGitHub', url: 'https://github.com/josemcortesh/DevOps-Ansible_Project1.git']])
//            }
//        }
/*        stage('Deploy Ansible Playbook'){
            steps{
                script{
                    // retry at least 5 times as the EC2 instances could be still loading.
                    retry(5){
                    
                        // Change to the directory where the ansible playbooks are located.
                        dir('./AnsiblePlaybooks') {
                            withAWS(credentials: 'DevOpsLabs') {
                                ansiblePlaybook credentialsId: 'AnsibleLabUser', installation: 'Ansible-Local', inventory: 'ansiworkers.aws_ec2.yml', playbook: 'CloneAndBuildCode-Playbook.yml'
                                sh 'echo "This line confirms that the first playbook has been executed"'
                        
                                ansiblePlaybook credentialsId: 'AnsibleLabUser', installation: 'Ansible-Local', inventory: 'ansiworkers.aws_ec2.yml', playbook: 'DockerCleanUp-Playbook.yml'
                                sh 'echo "this line confirms thea the second playbook has been executed"'
                            
                                ansiblePlaybook credentialsId: 'AnsibleLabUser', installation: 'Ansible-Local', inventory: 'ansiworkers.aws_ec2.yml', playbook: 'DeployOnDocker-Playbook.yml'
                                sh 'echo "This line confirms that the third playbook has been executed"'
                            }
                        }    
                    }
                }
            }
        }*/
    }
}
