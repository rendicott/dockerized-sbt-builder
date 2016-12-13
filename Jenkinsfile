currentBuild.result = "SUCCESS"

def buildPrefix = '0.0.1.'
def buildBranch = 'release/release2-autobuild'

// hipchatSend "Build Started - ${env.JOB_NAME} ${env.BUILD_NUMBER} (Open)"

try {
    node('docker-gsmith-1'){
        stage 'cleanup'
        deleteDir()
        
        stage 'checkout source'
        def buildNumber = "${buildPrefix}${env.BUILD_NUMBER}"
        print buildNumber
        checkout scm
        sh "echo WORKSPACE will be : \$PWD"
        stage "run dockerized build box"
        sh "docker run snoo ./build.sh ${env.BUILD_NUMBER} ${buildBranch}"
        stage "run dockerized rpm packaging box"
        sh "docker run tata ./package.sh ${env.BUILD_NUMBER} ${buildBranch}" 
    }
} catch (error) {
    mail ('to': 'cool_dude@company.com',
          'subject': "Job '${env.JOB_NAME}' (${env.BUILD_NUMBER}) Failed",
          'body': "Please go to ${env.BUILD_URL}.");
} finally {
    hipchatSend "Build Finished - ${env.JOB_NAME} ${env.BUILD_NUMBER}"
}
