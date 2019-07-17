pipeline {
  environment {
    AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
  }
  agent {
    dockerfile {
      filename 'Dockerfile'
      dir 'test'
      additionalBuildArgs '--build-arg aws_key=$AWS_ACCESS_KEY_ID --build-arg aws_secret=$AWS_SECRET_ACCESS_KEY'
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
