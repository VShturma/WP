pipeline {
  environment {
    AWS_CREDS = credentials('9b9267bb-c564-4683-b5ab-df3308db5b57')
  }
  agent {
    dockerfile {
      filename 'Dockerfile'
      dir 'test'
      additionalBuildArgs '--build-arg aws_key=${MYVARNAME_USR} --build-arg aws_secret=${MYVARNAME_PSW}'
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
