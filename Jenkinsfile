pipeline {
  environment {
    AWS_CREDS = credentials('9b9267bb-c564-4683-b5ab-df3308db5b57')
  }
  agent {
    dockerfile {
      filename 'DockerfileTestingImage'
      additionalBuildArgs '--build-arg aws_key=$MYVARNAME_USR --build-arg aws_secret=$MYVARNAME_PSW -t terraform:v1'
    }
  }
  stages {
    stage('Build') {
      agent {
        docker {
          image 'terraform:v1'
        }
      }
      steps {
        sh '/go/bin/dep ensure'
      }
    }
    stage('Test') {
      agent {
        docker {
          image 'terraform:v1'
        }
      }
      steps {
        sh '''go test -v -count=1 -timeout 90m .
'''
      }
    }
  }
}
