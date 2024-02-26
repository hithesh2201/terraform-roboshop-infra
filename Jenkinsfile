pipeline {
   agent {
        label 'agent-1'
    }
    // agent any
    parameters {
        choice(name: 'deploy', choices: ['apply','destroy'], description: 'Select the action')
        
    }

    options {
        timeout(time: 1, unit: 'HOURS') // Set a timeout for the entire pipeline
        ansiColor("xterm") 
        disableConcurrentBuilds()

    }

    stages {
        stage('VPC') {
            steps {
                sh """
                cd 01-vpc
                terraform init
                terraform plan
                terraform ${params.deploy} -auto-approve
                """
            }
        }
        stage('SG') {
            steps {
                sh """
                cd 02-sg
                terraform init
                terraform plan
                terraform ${params.deploy} -auto-approve
                """
            }
        }

        stage('VPN') {
            steps {
                sh """
                cd 03-vpn
                terraform init
                terraform plan
                terraform ${params.deploy} -auto-approve
                """
            }
        }

    

        stage('DB and APP_ALB') {
            steps {
                parallel(
                    "DB": {
                        sh """
                        cd 04-databases
                        terraform init
                        terraform plan
                        terraform ${params.deploy} -auto-approve
                        """
                    },
                    "APP_ALB": {
                        sh """
                        cd 05-app_alb
                        terraform init
                        terraform plan
                        terraform ${params.deploy} -auto-approve
                        """
                    }
                )
            }
        }

        

        
    }

    post {
        success {
            echo "Pipeline completed successfully. Sending notification..."
            // Add notification steps for successful builds
        }

        failure {
            echo "Pipeline failed. Sending notification..."
            // Add notification steps for failed builds
        }

        always {
            echo "Cleaning up..."
            // Add any cleanup steps that should run regardless of success or failure
            deleteDir() //after every build it will remove folder and logs of current build
        }
    }
}
