
// Jenkins Scripted Pipeline for OLTRS

properties([
    pipelineTriggers([
        [$class: 'GitHubPushTrigger']
    ])
])

node {

    def dockerImage = 'yourdockerhubusername/oltrs'
    def shortCommit = ''

    try {

        // Stage 1: Checkout
        stage('Checkout') {

            echo 'Checking out OLTRS source code from GitHub'

            git branch: 'master',
                url: 'https://github.com/archanareddyse/OLTRS.git'

            shortCommit = sh(
                script: 'git rev-parse --short HEAD',
                returnStdout: true
            ).trim()

            echo "Checked out commit: ${shortCommit}"
        }

        // Stage 2: Maven Build and Test
        stage('Build and Test') {

            echo 'Building and testing OLTRS using Maven'

            sh 'mvn -B clean verify'
        }

        // Stage 3: Docker Image Build
        stage('Docker Build') {

            echo 'Creating Docker image'

            
withCredentials([
    usernamePassword(
        credentialsId: 'dockerhub-creds',
        usernameVariable: 'DOCKERHUB_USER',
        passwordVariable: 'DOCKERHUB_TOKEN'
    )
]) {

    withEnv([
        "IMAGE_NAME=${dockerImage}",
        "GIT_COMMIT_SHORT=${shortCommit}"
    ]) {

        sh '''
            echo "$DOCKERHUB_TOKEN" | docker login \
              -u "$DOCKERHUB_USER" --password-stdin

            docker push "$IMAGE_NAME:$BUILD_NUMBER"
            docker push "$IMAGE_NAME:latest"
            docker push "$IMAGE_NAME:$GIT_COMMIT_SHORT"

            docker logout
        '''
    }
}

        // Stage 4: Push Docker Image
        stage('Docker Push') {

            echo 'Pushing Docker image to Docker Hub'

            withCredentials([
                usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_TOKEN'
                )
            ]) {

                withEnv(["IMAGE_NAME=${dockerImage}"]) {

                    sh '''
                        echo "$DOCKERHUB_TOKEN" | docker login \
                          -u "$DOCKERHUB_USER" --password-stdin

                        docker push "$IMAGE_NAME:$BUILD_NUMBER"
                        docker push "$IMAGE_NAME:latest"
                        docker push "$IMAGE_NAME:$GIT_COMMIT_SHORT"
                    '''
                }
            }
        }

        echo 'OLTRS CI/CD Pipeline completed successfully'

    } catch (err) {

        currentBuild.result = 'FAILURE'

        echo "Pipeline failed: ${err}"

        throw err

    } finally {

        // Publish Maven test reports
        junit(
            testResults: '**/target/surefire-reports/*.xml',
            allowEmptyResults: true
        )

        // Send email only when pipeline fails
        if (currentBuild.currentResult == 'FAILURE') {

            emailext(
                to: 'your-email@example.com',
                subject: "OLTRS Pipeline FAILED - Build #${env.BUILD_NUMBER}",
                body: """
                OLTRS Jenkins Pipeline has failed.

                Build Number: ${env.BUILD_NUMBER}
                Job Name: ${env.JOB_NAME}
                Build URL: ${env.BUILD_URL}

                Please check the Jenkins console output.
                """
            )
        }
    }
}
