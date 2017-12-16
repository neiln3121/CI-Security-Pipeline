// this will start an executor on a Jenkins agent with the docker label
pipeline {
  agent any
  stages {
    stage('Run Image') {
      steps {
        sh 'docker pull psiinon/bodgeit'
        sh 'docker network create security-tests'
        sh 'run --rm --net security-tests --name webapp -p 50000:8080 -i -t psiinon/bodgeit'
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
                      reportDir            : 'report',
                      reportFiles          : 'zap-report.html',
                      reportName           : "ZAP Report"
              ]
            )

          archiveArtifacts artifacts: 'artifacts/**', fingerprint: true
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
        }
    }
    stage('Clean up') {
      steps {
        sh 'docker stop webapp'
        sh 'docker stop zap'
        sh 'docker rm arachni_report'
        sh 'docker network rm security-tests'
      }
    }
  }
}