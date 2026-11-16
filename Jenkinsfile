
properties([
    pipelineTriggers([
        [$class: 'GitHubPushTrigger']
    ])
])

node {

    try {

        stage('Checkout') {
            echo 'Checking out OLTRS source code'

            git branch: 'master',
                url: 'https://github.com/vishalreddy0116/OLTRS.git'

            echo 'Checkout successful'
        }

        stage('Build and Test') {
            echo 'Building OLTRS application'

            bat 'mvn -B clean verify'

            echo 'Build successful'
        }

        stage('Deploy to Tomcat') {
            echo 'Deploying OLTRS application'

            bat '''
                copy /Y target\\ticket-reservation.war C:\\Tomcat9\\webapps\\ROOT.war

                if errorlevel 1 exit /b 1
            '''

            echo 'Deployment successful'
        }

        echo 'OLTRS CI/CD Pipeline completed successfully'

    } catch (err) {

        currentBuild.result = 'FAILURE'

        echo "Pipeline failed: ${err}"

        throw err

    } finally {

        junit(
            testResults: '**/target/surefire-reports/*.xml',
            allowEmptyResults: true
        )
    }
}
