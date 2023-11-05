<p align="center">
<img src="https://github.com/djtoler/Deployment7/blob/main/dp7_assets/dp7img.png">
</p>

## Table of Contents
1. [Purpose](#purpose)
2. [Issues](#issues)
3. [Creating CICD Pipeline and Infrastructure](#create-cicd-pipeline-and-infrastructure)
4. [Explaining CICD Pipeline and Infrastructure](#cicd-pipeline-and-infrastructure-explanation)
5. [Application Successfully Deployed](#successful-deployment)
6. [System Diagram](#system-diagram)
7. [System Optimization](#system-optimization)

## Purpose
## Issues
* #### Error for having too many VPC's in our AWS account: _Deleted unused VPC from account_
* #### Thought we needed EC2 instances to run our Dockerfiles: _Re-read .tf files, visited load balancer URL & saw application running_
* #### AWS naming conventions dont allow undersocres in certain resources like Application Load Balancer names: _Changed names with underscores to dashes_
* #### Docker image name mispelled: _Check error logs and fix spelling error_
* #### Dockerfile trying to write duplicate entry into database when running the `load-data.py` file: _Remove database files from Dockerfile since the data was already loaded in previous Jenkins build attempts_

---

## Steps
### _Create CICD Pipeline and Infrastructure_
* #### [Create a remote GitHub repository](https://github.com/djtoler/automated_installation_scripts/blob/main/auto-github_repo_create.sh)
* #### Clone the banking application repository
```
    git clone https://github.com/djtoler/Deployment7.git
    cd Deployment7
```
* #### Create a `dev` branch in the repository and switch to it
```
    git checkout -b dev
```
* #### Make a `Dockerfile` for our Jenkins pipeline to build a Docker image from
* #### Create a distributed Jenkins CICD infrastructure architecture using Terraform
    * #### Create an EC2 instance for our `Jenkins Controller` [using this userdata script](https://github.com/djtoler/Deployment7/blob/main/ud_jenkins_controller.sh) 
    * #### Create an EC2 instance for our `Jenkins-Terraform agent` [using this userdata script](https://github.com/djtoler/Deployment7/blob/main/ud_jenkins_agent_tf.sh)
    * #### Create an EC2 instance for our `Jenkins-Docker agent`[ using this userdata script](https://github.com/djtoler/Deployment7/blob/main/ud_docker_instance.sh)
    * #### Deploy infrastructure [using this automated deployment script](https://github.com/djtoler/Deployment7/blob/main/tf_deploy.sh)
* #### Log into Jenkins server 
    * #### Add DockerHub credentials
    * #### Add AWS credentials
    * #### Install `Utility Pipeline Steps` & `Docker Pipeline` plugins
    * #### [Create 2 Jenkins agents](https://github.com/djtoler/automated_installation_scripts/blob/main/manual-jenkins_agent.txt): 1 for our Terraform instance and 1 for our Docker instance
    * #### Edit enviornment variables & Docker image references in Jenkinsfile
    * #### [Create a multi branch pipeline](https://github.com/djtoler/automated_installation_scripts/blob/main/manual_jenkins_multi_branch.txt)
  
### _CICD Pipeline and Infrastructure Explanation_
#|<span style="width:200px">Step</span>|<span style="width:300px">Purpose</span>| Jenkinsfile  | <span style="width:200px">Business Case</span>  |
|---|---|---|---|---|
|1. |_Jenkins controller tells Docker agent to start working the pipeline_| Efficently handle workloads using a distributed system strategy  | ![1](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/1.PNG)   |  _Save money by configuring workload specific instances_ |
|2. |_DockerHub credentials set in Jenkins enviornment_| Authorization to programatically push Docker images to DockerHub  | ![2](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/2dockercreds.PNG)  |  _Save money  by reducing manual labor costs_ |
|3. |_Test application dependencies in virtual enviornment_| Catch configuration drifts and errors in a controlled, isolated enviornment before building our Docker image  | ![3](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/3.PNG)  | _Make more money by preventing downtime that could result in potential missed transactions_  |
|4. |_Build a Docker image of our banking application_| Continuously intergrate application code changes into our Docker image  | ![4](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/4dockerfiledp7.PNG)  |  _Make more money by having application new features and updates will be available to customers faster_ |
|5. |_Programatically log into DockerHub account using credentials from step 2_| Automate pushing Docker image to DockerHub repo    | ![5](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/5.PNG)  | _Save money  by reducing manual labor costs_  |
|6. | _Push updated Docker image to DockerHub repo_ | Make the latest version of our applications Docker image available for download | ![6](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/6.PNG) |  _Make more money by having application new features and updates will be available to customers faster_ |
|7.|  _Jenkins controller tells Terraform agent to take over pipeline execution steps_  | Leverage Jenkins distributed architecture to operate in a enviornment specifically configured for deploying AWS infrastructure   | ![7](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/7.PNG)  |  _Save money by configuring workload specific instances_ |
|8. | _Run `terraform init`_ | Terraform sets up context to deploy resources in like providers, state files...| ![8](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/8.PNG)  |  |   
|9. | _Run `terraform plan -out plan.tfplan`_| Terraform compares current state of resources to our `.tf` files, makes a plan to deploy what we ask for and saves it to a file called `tfplan.tf` | ![9](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/9.PNG)  | _Save money by checking deployment plan before potentially deploying wrong resources_  |
|10. | _Run `terraform apply plan.tfplan`_|Terraform attempts to deploy the resources saved in the `plan.tfplan` file from step 9| ![10](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/10.PNG) | _Make more money with flexible infrastructure configuration and save money by automating infrastructure deployment_   |   
|#|Step| Purpose  | Terraform  | Business Case  |
|11. | _Create the following<br><ul><li>VPC</li><li>2 Private Subnets</li><li>2 Public Subnets</li><li>Elastic IP</li><li>Internet Gateway</li><li>NAT Gateway</li><li>Public Route Table</li><li>Private Route Table</li><li>Load Balancer Security Group(Port 80)</li><li>Application Security Group(Port 8080)</li></ul>_ | Set the foundation to deploy our application infrastructure onto |  ![vpc](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/vpc.PNG)    |  _Make money & save money using cloud infrastructure that can quickly be built or destroyed. This can reduce operating costs & make access to business oppertunities more affordable to facilitate_ | 
|12. | _Create a listener for the load balancer_| To set the rules for the load balancer like which port to listen on, what to do with requests...| ![12](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/11.PNG)  | _Save/make money by strategically optimizing traffic distribution_  |  
|13. | _Create a application load balancer_ | To route traffic based on certain requirements | ![13](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/12.PNG)  |   |
|14. | _Create a load balancer target group_ | To logically group resources together for the load balancer to route requests to (like web server group and application server group)| ![14](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/13.PNG) | _Make money by optimizing resources in target groups for specific types of requests_  |
|15. | _Create a ECS cluster_ | For AWS to run our Docker containers | ![15](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/14.PNG)  |  _Save money by reducing costs of managing container infrastructure_ |
|16. | _Create a ECS task definition_ | For defining our containers configuration such as the image to build the container from, the ports to open on the container...| ![16](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/15.PNG)  | _Save money by running applications in lean containerized enviornments_ |
|17. | _Create a ECS service_ | For defining our container context like what cluster/tasks definition we'll use, how many tasks and the load balancer we'll use to route our container traffic | ![17](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/16.PNG)  |  _Save money by optimizing the context of container configurations_  |
|18a. | _Terraform successfully deploys our infrastructure_| To continuiously deploy our containerized banking application in a private subnet, only available via our application load balancer URL | ![18](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/18a.PNG)  |  |
### _Successful Deployment_
<p align="center">
<img src="https://github.com/djtoler/Deployment7/blob/main/dp7_assets/dp7-alb.PNG">
</p>

---

## System Diagram

<p align="center">
<img src="https://github.com/djtoler/Deployment7/blob/main/dp7Diagram.png">
</p>

---

## System Optimization
