pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    } 
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/sheetal-nain/redis.git', branch: 'main'
            }
        }

        stage('Plan') {
            steps {
                sh 'pwd;cd terraform/ ; terraform init'
                sh 'pwd;cd terraform/ ; terraform validate'
                sh 'pwd;cd terraform/ ; terraform plan'
            }
        }

        stage('Apply/Destroy') {
            steps {
                sh 'pwd;cd terraform/ ; terraform ${action} --auto-approve'
            }
        }

        // Adding sleep after terraform apply
        stage('Sleep After Apply') {
            when {
                expression {
                    return params.action == 'apply'  // Run this only if action is 'apply'
                }
            }
            steps {
                echo "Sleeping for 10 seconds after terraform apply"
                sleep 10
            }
        }

        // New stage to run the Ansible playbook with manual approval
        stage('Approve and Run Ansible Playbook') {
            when {
                expression {
                    return params.action == 'apply'  // Only run for 'apply' action
                }
            }
            steps {
                input message: 'Do you approve running the Ansible playbook?', ok: 'Yes', submitter: 'user'
                script {
                    echo "Running Ansible Playbook..."
                    sh 'ansible-playbook -i aws_ec2.yaml playbook.yml'  // Playbook name
                }
            }
        }
    }
}
