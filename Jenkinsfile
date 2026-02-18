pipeline{
  agent any

  environment { // Set AWS credentials as environment variables for Terraform
    AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')  // Jenkins credentials ID for AWS Access Key ID
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY') // Jenkins credentials ID for AWS Secret Access Key
    AWS_DEFAULT_REGION = 'eu-west-2'
  }
  stages {
    stage('Terraform Init') { //Stage for initialiazing Terraform we use different stages for each command to make it more clear and easy to debug
        steps {
            sh 'ls' // we use shell command to run terraform commands in the terminal and we use ls to check if we are in the correct directory and if the terraform files are there
            sh 'terraform init -no-color'
        }
    }
    
    stage('Terraform Plan'){
        steps {
            sh 'terraform plan -no-color'
        }
    }
    stage('Terraform Apply'){
        steps {
            sh 'terraform apply -auto-approve -no-color'
        }
    }
  }
}
