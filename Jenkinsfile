pipeline {
  environment {
    AWS_CREDS = credentials('aws-creds')
  }
  agent {
    dockerfile {
      filename 'Dockerfile'
      dir 'test'
      additionalBuildArgs '--build-arg aws_key=$AWS_CREDS_USR --build-arg aws_secret=$AWS_CREDS_PSW'
    }
  }
  stages {
    stage('Build') {
      steps {
        sh 'cd /go/src/wordpress/test && /go/bin/dep ensure'
      }
    }
    stage('Test') {
      steps {
        sh '''cd /go/src/wordpress/test && go test -v -count=1 -timeout 90m .
'''
      }
    }
  }
}
