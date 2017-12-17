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
                      alwaysLinkToLastBuild: true,
                      keepAll              : true,
                      reportDir            : 'artifacts',
                      reportFiles          : 'zap-report.html',
                      reportName           : "ZAP Report"
              ]
            )

          publishHTML (
              target: [
                  allowMissing         : false,
                  alwaysLinkToLastBuild: true,
                  keepAll              : true,
                  reportDir            : 'artifacts',
                  reportFiles          : 'index.html',
                  reportName           : "ARACHNI Report"
              ]
            )
          archiveArtifacts artifacts: 'artifacts/**', fingerprint: true
        }
    }
    stage('Clean Up') {
        steps {
          sh 'docker stop webapp'
        }
    }
  }
}