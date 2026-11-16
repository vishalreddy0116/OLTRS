
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

        stage('Package Application') {
            echo 'Packaging OLTRS application'

            archiveArtifacts(
                artifacts: 'target/ticket-reservation.war',
                fingerprint: true
            )

            echo 'WAR file archived successfully'
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
