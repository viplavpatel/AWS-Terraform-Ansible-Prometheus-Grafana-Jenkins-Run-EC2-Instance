pipeline{
  agent any
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
