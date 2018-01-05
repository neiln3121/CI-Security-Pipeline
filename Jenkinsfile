// this will start an executor on a Jenkins agent with the docker label
pipeline {
  agent any
  stages {
    stage('Run Image') {
      steps {
        sh 'docker run --rm --name webapp -it -d -p 5000:8080 psiinon/bodgeit'
      }
    }
    stage('Run Security Tests') {
        steps {
          sh './security-tests.sh'
          publishHTML (
              target: [
                      allowMissing         : false,
                      alwaysLinkToLastBuild: false,
                      keepAll              : true,
                      reportDir            : 'zap',
                      reportFiles          : 'zap-report.html',
                      reportName           : "ZAP Report"
              ]
            )

          publishHTML (
              target: [
                  allowMissing         : false,
                  alwaysLinkToLastBuild: false,
                  keepAll              : true,
                  reportDir            : 'arachi',
                  reportFiles          : 'index.html',
                  reportName           : "ARACHNI Report"
              ]
            )
          
          sh 'docker stop webapp'
        }
    }
  }
}