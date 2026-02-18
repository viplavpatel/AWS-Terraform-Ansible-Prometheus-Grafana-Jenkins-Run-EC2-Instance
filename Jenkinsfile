pipeline{
  agent any

  environment {
    AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    AWS_DEFAULT_REGION = 'eu-west-2'
  }
  stages {
    stage('Terraform Init') {
        steps {
            sh 'ls'
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
