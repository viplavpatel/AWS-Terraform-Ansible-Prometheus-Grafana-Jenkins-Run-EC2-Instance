pipeline{
  agent any

  environment { // Set AWS credentials as environment variables for Terraform
    AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')  // Jenkins credentials ID for AWS Access Key ID
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY') // Jenkins credentials ID for AWS Secret Access Key
    AWS_DEFAULT_REGION = 'eu-west-2'
    AWS_SHARED_CREDENTIALS_FILE = '~/.aws/credentials' // Path to AWS credentials file, refers to /home/ec2-user/.aws/credentials in WSL, used to access EC2 instance for Ansible playbooks
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
    stage('Validate Apply'){
        input {
            message "Do you want to apply this plan ?" // we use input step to ask the user if they want to apply the changes or not, this is a manual step to ensure that the user has reviewed the plan and is aware of the changes that will be made to the infrastructure before applying them
            ok "Apply Plan..." // this is the text that will be displayed on the button that the user will click to apply the plan
        }
        steps{ //disclaimer: "steps", "stages" or "parallel" have to be there inside a stage otherwise it wont work only with "input" and "message" and "ok"
            echo 'Apply accepted, applying changes...' // this is a message that will be displayed in the Jenkins console when the user clicks the button to apply the plan
        }
    }
    stage('Terraform Apply'){
        steps {
            sh 'terraform apply -auto-approve -no-color'
        }
    }
    
    stage('EC2 wait'){
        steps{
            sh 'aws ec2 wait instance-status-ok --region eu-west-2' // we use aws cli command to wait for the EC2 instance to be in running state before we run the ansible playbooks
        }
    }
    stage('ssh key permission'){
        steps{
            sh 'chmod 400 ./linuxkey.pem' // we use chmod command to set the permissions of the ssh key to 400 to make it more secure and to avoid any permission issues when we run the ansible playbooks
        }
    }
    stage('Validate Ansible'){
        input{
            message "Do you want to run Ansible Playbook ?" // we use input step to ask the user if they want to run the ansible playbook or not, this is a manual step to ensure that the user has reviewed the changes that will be made to the infrastructure before applying them
            ok "Run Ansible Playbook..." // this is the text that} will be displayed on the button that the user will click to run the ansible playbook
        }

            steps{
                echo 'Running Ansible Playbook...' // this is a message that will be displayed in the Jenkins console when the user clicks the button to run the ansible playbook
            }
        }
    
    stage('Run Ansible Playbook'){
        steps{
            ansiblePlaybook(credentialsId: 'ec2-ssh-key', inventory: 'aws_hosts', playbook: 'playbooks/prometheus.yml') // we use ansible-playbook command to run the playbook that installs prometheus and grafana on the EC2 instance
        }
    }
    stage('Validate Terraform Destroy'){
        input{
            message "Do you wwant to destroy the infrastructure ?" // we use input step to ask the user if they want to destroy the infrastructure or not, this is a manual step to ensure that the user has reviewed the changes that will be made to the infrastructure before destroying it
            ok "Destroy infrastructure" // this is the text that will be displayed on the button that the user will click to destroy the infrastructure
        }
            steps{
                echo 'Destroying infrastructure ....'
            }
        }
    
                
    stage('Terraform Destroy'){
        steps{
            sh 'terraform destroy -auto-approve -no-color'
        }
    }
  }
  post{
    success {
        echo 'Pipeline completed successfully!' // this is a message that will be displayed in the Jenkins console when the pipeline completes successfully
    }
  }
  post{
    failure {
       sh 'terraform destroy -auto-approve -no-color' // this is a command that will be run in the Jenkins console when the pipeline fails, it will destroy the infrastructure to avoid any unnecessary costs
       echo 'Pipeline failed, infrastructure destroyed to avoid unnecessary costs.' // this is a message that will be displayed in the Jenkins console when the pipeline fails and the infrastructure is destroyed
    }
  }
}

  

