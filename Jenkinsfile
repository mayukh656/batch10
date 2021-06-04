try{
    node{
        def mavenHome
        def mavenCMD
        def docker
        def dockerCMD
        def tagName = "1.0"
        stage('Preparation'){
              echo "Preparing the Jenkins environment with required tools..."
              mavenHome = tool name: 'Maven1', type: 'maven'
              mavenCMD = "${mavenHome}/bin/mvn"
              docker = tool name: 'docker1', type: 'org.jenkinsci.plugins.docker.commons.tools.DockerTool'
              dockerCMD = "$docker/bin/docker"
         }
         stage('git checkout'){
              echo "Checking out the code from git repository..."
              git 'https://github.com/mayukh656/batch10.git'
         }
              
         stage('Build, Test and Package'){
            echo "Building the springboot application..."
            sh "${mavenCMD} clean package"
		 sh "${mavenCMD} site"
         }
              
         stage('Sonar Scan'){
             echo "Scanning application for vulnerabilities..."
	     withSonarQubeEnv(credentialsId: 'sonarqube-tkn') {
	     sh "${mavenCMD} sonar:sonar -Dsonar.host.url=http://35.238.38.115:9000"
             }
          }
     
          stage('Integration test'){
             echo "Executing Regression Test Suits..."
                  // command to execute selenium test suits
          }
              
          stage('publish report'){
             echo " Publishing HTML report.."
             publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: ''])
          }
              
          stage('Build Docker Image'){
             echo "Building docker image for springboot application ..."
             sh "${dockerCMD} build -t mayukh656/springboot:${tagName} ."
          }
              
          stage("Push Docker Image to Docker Registry"){
              echo "Pushing image to docker hub"
	      withCredentials([usernamePassword(credentialsId: 'dhub', passwordVariable: 'dhubPwd', usernameVariable: 'mycreds')]) {
              sh "${dockerCMD} login -u mayukh656 -p ${dhubPwd}"
	      sh "${dockerCMD} push mayukh656/springboot:${tagName}"
	      }
          }
              
      	  stage('Deploy Application'){
	       echo "Installing desired software.."
	       echo "Bring docker service up and running"
	       echo "Deploying springboot application"
	       ansiblePlaybook credentialsId: '703a4ec3-4a11-4e97-bb64-14e8644f36ad', disableHostKeyChecking: true, installation: 'ansible 2.9.22', inventory: '/etc/ansible/hosts', playbook: 'deploy-playbook.yml'		      
          }
              
           stage('Clean up'){
              echo "Cleaning up the workspace..."
              cleanWs()
              }
          }
      }
catch(Exception err){
     echo "Exception occured..."
     currentBuild.result="FAILURE"
          //send an failure email notification to the user.
}
finally {
     (currentBuild.result!= "ABORTED") && node("master") {
      echo "finally gets executed and end an email notification for every build"
      emailext body: 'Your build has been successful or unsuccessful', subject: 'Jenkins Mail', to: 'jetscmlearning@gmail.com'
          }
}

