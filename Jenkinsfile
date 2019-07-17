pipeline {
  agent {
    dockerfile {
      filename 'DockerfileTestingImage'
    }

  }
  stages {
    stage('Build') {
      steps {
        sh '/go/bin/dep ensure'
      }
    }
    stage('Test') {
      steps {
        sh '''go test -v -count=1 -timeout 90m .
'''
      }
    }
  }
}