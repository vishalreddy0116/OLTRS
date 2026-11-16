
properties([
    pipelineTriggers([
        [$class: 'GitHubPushTrigger']
    ])
])

node {
    try {

        // Stage 1
        stage('Checkout') {
            echo 'Checking out OLTRS source code'

            git branch: 'master',
                url: 'https://github.com/vishalreddy0116/OLTRS.git'
        }

        // Stage 2
        stage('Build') {
            echo 'Building OLTRS application'
            bat 'mvn -B clean compile'
        }

        // Stage 3
        stage('Test') {
            echo 'Running application tests'
            bat 'mvn -B test'
        }

        // Stage 4
        stage('Package') {
            echo 'Creating WAR file'
            bat 'mvn -B package -DskipTests'
        }

        // Stage 5
        stage('Archive Artifacts') {
            echo 'Archiving WAR file'

            archiveArtifacts(
                artifacts: 'target/ticket-reservation.war',
                fingerprint: true
            )
        }

        echo 'OLTRS pipeline completed successfully'

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
