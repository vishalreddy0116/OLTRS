
properties([
    pipelineTriggers([
        [$class: 'GitHubPushTrigger']
    ])
])

node {

    try {

        // Stage 1: Checkout
        stage('Checkout') {
            echo 'Fetching OLTRS source code from GitHub'

            git branch: 'master',
                url: 'https://github.com/vishalreddy0116/OLTRS.git'

            echo 'Source code checkout successful'
        }

        // Stage 2: Build
        stage('Build') {
            echo 'Building OLTRS application'

            bat 'mvn -B clean compile'

            echo 'Compilation successful'
        }

        // Stage 3: Test
        stage('Test') {
            echo 'Running OLTRS tests'

            bat 'mvn -B test'

            echo 'Testing stage completed'
        }

        // Stage 4: Package
        stage('Package') {
            echo 'Packaging OLTRS application'

            bat 'mvn -B package -DskipTests'

            echo 'WAR packaging successful'
        }

        // Stage 5: Archive Artifacts
        stage('Archive Artifacts') {
            echo 'Archiving generated WAR file'

            archiveArtifacts(
                artifacts: 'target/ticket-reservation.war',
                fingerprint: true
            )

            echo 'Artifact archived successfully'
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
