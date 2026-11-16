
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
        }

        stage('Build') {
            echo 'Building OLTRS application'
            bat 'mvn -B clean compile'
        }

        stage('Test') {
            echo 'Running application tests'
            bat 'mvn -B test'
        }

        stage('Package') {
            echo 'Creating WAR file'
            bat 'mvn -B package -DskipTests'
        }

        stage('Archive Artifacts') {
            echo 'Archiving WAR file'

            archiveArtifacts(
                artifacts: 'target/ticket-reservation.war',
                fingerprint: true
            )
        }

        stage('Continuous Delivery') {
            echo 'Preparing application for delivery'

            bat '''
                if not exist target\\ticket-reservation.war exit /b 1
                echo OLTRS WAR artifact is ready for deployment
            '''

            echo 'Continuous Delivery completed successfully'
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
