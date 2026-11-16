
properties([
    pipelineTriggers([
        [$class: 'GitHubPushTrigger']
    ])
])

node {

    def dockerImage = 'vishalreddy0116/oltrs'
    def shortCommit = ''

    try {

        // Stage 1: Checkout
        stage('Checkout') {

            echo 'Checking out OLTRS source code'

            git branch: 'master',
                url: 'https://github.com/vishalreddy0116/OLTRS.git'

            shortCommit = bat(
                script: '@echo off\r\n"C:\\Program Files\\Git\\mingw64\\bin\\git.exe" rev-parse --short HEAD',
                returnStdout: true
            ).trim()

            echo "Commit: ${shortCommit}"
        }

        // Stage 2: Build and Test
        stage('Build and Test') {

            echo 'Building and testing OLTRS'

            bat 'mvn -B clean verify'
        }

        // Stage 3: Docker Build
        stage('Docker Build') {

            echo 'Creating Docker image'

            bat """
                docker build -t ${dockerImage}:${env.BUILD_NUMBER} .
                if errorlevel 1 exit /b 1

                docker tag ${dockerImage}:${env.BUILD_NUMBER} ${dockerImage}:latest
                if errorlevel 1 exit /b 1

                docker tag ${dockerImage}:${env.BUILD_NUMBER} ${dockerImage}:${shortCommit}
                if errorlevel 1 exit /b 1
            """
        }

        // Stage 4: Docker Push
        stage('Docker Push') {

            echo 'Pushing image to Docker Hub'

            withCredentials([
                usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_TOKEN'
                )
            ]) {

                withEnv([
                    "IMAGE_NAME=${dockerImage}",
                    "GIT_COMMIT_SHORT=${shortCommit}"
                ]) {

                    bat '''
                        @echo off

                        echo Logging into Docker Hub...

                        echo %DOCKERHUB_TOKEN% | docker login -u %DOCKERHUB_USER% --password-stdin

                        if errorlevel 1 exit /b 1

                        docker push %IMAGE_NAME%:%BUILD_NUMBER%
                        if errorlevel 1 exit /b 1

                        docker push %IMAGE_NAME%:latest
                        if errorlevel 1 exit /b 1

                        docker push %IMAGE_NAME%:%GIT_COMMIT_SHORT%
                        if errorlevel 1 exit /b 1

                        docker logout

                        echo Docker images pushed successfully!
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
    }
}
