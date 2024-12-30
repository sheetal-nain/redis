pipeline {
    agent any
    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Select action: apply or destroy')
    }
    environment {
        // Define AWS credentials as environment variables
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        REGION                = 'ap-south-1'
    }
    stages {
        stage('Checkout') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                // Check out the repository with Terraform code
                git branch: 'main', 
                    url: 'https://github.com/sheetal-nain/redis.git'
            }
        }
        stage('Terraform Init') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                dir('terraform') {
                    sh '''
                        terraform init -migrate-state  \
                        -backend-config="bucket=terraform-bucket-a" \
                        -backend-config="key=terraform/state" \
                        -backend-config="region=${REGION}" 
                    '''
                }
            }
        }
        stage('Terraform Plan') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                dir('terraform') {
                    sh 'terraform plan -lock=false'
                }
            }
        }
        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                dir('terraform') {
                    sh '''
                        terraform apply -auto-approve -lock=false
                    '''
                }
            }
        }
        stage('Approval for Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                // Prompt for approval before destroying resources
                input "Do you want to Terraform Destroy?"
            }
        }
        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                dir('terraform') {
                    sh 'terraform destroy -auto-approve'
                }
            }
            post {
                always {
                    // Cleanup workspace after the build
                    cleanWs()
                }
            }
        }
        stage('Ansible Playbook Execution') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                dir('terraform') {
                    // Checking if the output files exist before proceeding
                    script {
                        def bastionIpPath = "${env.WORKSPACE}/terraform/bastion_ip.txt"
                        def redisIpPath = "${env.WORKSPACE}/terraform/redis_ip.txt"
                        if (fileExists(bastionIpPath) && fileExists(redisIpPath)) {
                            def bastionIp = readFile(bastionIpPath).trim()
                            def redisIp = readFile(redisIpPath).trim()

                            // Dynamically creating the inventory file with the correct IP addresses
                            writeFile file: 'inventory', text: """
                            [bastion]
                            ${bastionIp} ansible_ssh_private_key_file=/home/ubuntu/ninja.pem ansible_user=ubuntu
                            [Redis]
                            ${redisIp} ansible_ssh_private_key_file=/home/ubuntu/ninja.pem ansible_user=ubuntu
                            """

                            // Disable host key checking during scp and ssh
                            sh """
                                scp -o StrictHostKeyChecking=no -i /home/ubuntu/ninja.pem /home/ubuntu/ninja.pem ubuntu@${bastionIp}:/home/ubuntu/
                                ssh -o StrictHostKeyChecking=no -i /home/ubuntu/ninja.pem ubuntu@${bastionIp} 'sudo chmod 400 /home/ubuntu/ninja.pem'
                            """

                            sh '''
                            ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory /var/lib/jenkins/workspace/Redis/playbook.yml
                            '''
                        } else {
                            error "One or both of the IP files (bastion_ip.txt, redis_ip.txt) were not found!"
                        }
                    }
                }
            }
        }
    }
}
