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

   agent  any
        stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/sheetal-nain/redis.git', branch: 'main'
            }
        }

        stage('Plan') {
            steps {
                sh 'pwd;cd Terraform/ ; terraform init'
                sh 'pwd;cd Terraform/ ; terraform validate'
                sh 'pwd;cd Terraform/ ; terraform plan'
            }
        }
      
        stage('Apply/Destroy') {
            steps {
                sh 'pwd;cd Terraform/ ; terraform ${action} --auto-approve'
            }
        }
    }

}
