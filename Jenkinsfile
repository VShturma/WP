pipeline {
  environment {
    AWS_CREDS = credentials('9b9267bb-c564-4683-b5ab-df3308db5b57')
  }
  agent none
  stages {
    stage('Build') {
      agent {
        dockerfile {
          filename 'DockerfileTestingImage'
          additionalBuildArgs '--build-arg aws_key=$MYVARNAME_USR --build-arg aws_secret=$MYVARNAME_PSW'
        }
      }
      steps {
        sh '/go/bin/dep ensure'
      }
    }
    stage('Test') {
      agent {
        dockerfile {
          filename 'DockerfileTestingImage'
          additionalBuildArgs '--build-arg aws_key=$MYVARNAME_USR --build-arg aws_secret=$MYVARNAME_PSW'
        }
      }
      steps {
        sh '''go test -v -count=1 -timeout 90m .
'''
      }
    }
  }
}
