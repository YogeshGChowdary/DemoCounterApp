pipeline{
    
    agent any 
    
    stages {
        
        stage('Git Checkout'){
            
            steps{
                
                script{
                    
                    git branch: 'main', url: 'https://github.com/YogeshGChowdary/DemoCounterApp.git'
                }
            }
        }
        stage('UNIT testing'){
            
            steps{
                
                script{
                    
                    sh 'mvn test'
                }
            }
        }
        stage('Integration testing'){
            
            steps{
                
                script{
                    
                    sh 'mvn verify -DskipUnitTests'
                }
            }
        }
        stage('Maven build'){
            
            steps{
                
                script{
                    
                    sh 'mvn clean install'
                }
            }
        }
        stage('Static code analysis'){
            
            steps{
                
                script{
                    
                    withSonarQubeEnv(credentialsId: 'sonar-api') {
                        
                        sh 'mvn clean package sonar:sonar'
                    }
                   }
                    
                }
            }
            stage('Quality Gate Status'){
                
                steps{
                    
                    script{
                        
                        waitForQualityGate abortPipeline: false, credentialsId: 'sonar-api'
                    }
                }
            }

            stage('upload war file to nexus') {

                steps{

                    script{

                        def readPomVersion = readMavenPom file: 'pom.xml'

                        def nexusRepo = readPomVersion.version.endsWith("SNAPSHOT") ? "demoapp-snapshot" : "demoapp-release"
                        nexusArtifactUploader artifacts: 
                        [
                            [
                                artifactid: springboot, 
                                classifier: '', file: 'target/Uber.jar', 
                                type: 'jar'
                                ]
                        ], 
                        credentialsID: 'nexus-auth',
                        groupId: 'com.example',
                        nexusUrl: '3.226.224.16:8081',
                        nexusVersion: 'nexus3',
                        protocol: 'http',
                        repository: nexusRepo,
                        version: "${readPomVersion.version}"
                    }
                }
            }
            stage('Docker Image Build'){

                steps{

                    script{

                        sh 'docker image build -t $JOB_NAME:v1.$BUILD_ID .'
                        sh 'docker image tag $JOB_NAME:v1.$BUILD_ID yogeshf5/$JOB_NAME:v1.$BUILD_ID'
                        sh 'docker image tag $JOB_NAME:v1.$BUILD_ID yogeshf5/$JOB_NAME:v1.latest'

                    }
                }
            }

            stage('push image to DockerHub'){

                steps{

                    script{

                        withCredentials([string(credentialsId: 'docker-creds', variable: 'docker_hub_creds')]){

                            sh 'docker login -u yogeshf5 -p ${docker_hub_creds}'
                            sh 'docker image push yogeshf5/$JOB_NAME:v1.$BUILD_ID'
                            sh 'docker image push yogeshf5/$JOB_NAME:v1.latest'
                        }

                
                    }
                }
            }
        }              
}