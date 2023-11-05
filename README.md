## Purpose
## Issues
* #### Error for having too many VPC's in our AWS account
* #### Thought we needed a EC2 instances to run our Dockerfiles
* #### AWS naming conventions dont allow undersocres in certain resources like Application Load Balancer names
* #### Docker image naming convention
* #### Dockerfile trying to write duplicate entry into database when running the `load-data.py` file

---

## Steps
### _Create CICD Pipeline & Infrastructure_
* #### Clone the banking application repository
* #### Create a `dev` branch in the repository and switch to it
* #### Make a `Dockerfile` for our Jenkins pipeline to build a Docker image from
* #### Create a distributed Jenkins CICD infrastructure architecture using Terraform
    * #### Create an EC2 instance for our `Jenkins Controller` using this userdata script 
    * #### Create an EC2 instance for our `Jenkins-Terraform agent` using this userdata script
    * #### Create an EC2 instance for our `Jenkins-Docker agent` using this userdata script
    * #### Deploy infrastructure using this automated deployment script
* #### Log into Jenkins server 
    * #### Add DockerHub credentials
    * #### Add AWS credentials
    * #### Install `Utility Pipeline Steps` & `Docker Pipeline` plugins
    * #### Create 2 Jenkins agents
    * #### Edit enviornment variables & Docker image references in Jenkinsfile
    * #### Create a multi branch pipeline
  
### _CICD Pipeline & Infrastructure Explanation_
#|<span style="width:200px">Step</span>|<span style="width:300px">Purpose</span>| Jenkinsfile  | Business Case  |
|---|---|---|---|---|
|1. |_Jenkins controller tells Docker agent to start working the pipeline_| Efficently handle workloads using a distributed system strategy  | ![1](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/1.PNG)   |   |
|2. |_DockerHub credentials set in Jenkins enviornment_| Authorization to programatically push Docker images to DockerHub  | ![2](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/2dockercreds.PNG)  |   |
|3. |_Test application dependencies in virtual enviornment_| Catch configuration drifts and errors in a controlled, isolated enviornment before build our Docker image  | ![3](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/3.PNG)  |   |
|4. |_Build a Docker image of our banking application_| Continuously intergrate application code changes into our Docker image  | ![4](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/4dockerfiledp7.PNG)  |   |
|5. |_Programatically log into DockerHub account using credentials from step 2_| Automate pushing Docker image to DockerHub repo    | ![5](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/5.PNG)  |   |
|6. | _Push updated Docker image to DockerHub repo_ | Make the latest version of our applications Docker image available for download | ![6](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/6.PNG) |   |
|7.|  _Jenkins controller tells Terraform agent to take over pipeline execution steps_  | Leverage Jenkins distributed architecture to operate in a enviornment specifically configured for deploying AWS infrastructure   | ![7](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/7.PNG)  |   |
|8. | _Run `terraform init`_ | Terraform sets up context to deploy resources in like providers, state files...| ![8](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/8.PNG)  |   |   
|9. | _Run `terraform plan -out plan.tfplan`_| Terraform compares current state of resources to our `.tf` files, makes a plan to deploy what we ask for and saves it to a file called `tfplan.tf` | ![9](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/9.PNG)  |   |
|10. | _Run `terraform apply plan.tfplan`_|Terraform attempts to deploy the resources saved in the `plan.tfplan` file from step 9| ![10](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/10.PNG) |   |   
|#|Step| Purpose  | Terraform  | Business Case  |
|11. | _Create the following<br><ul><li>VPC</li><li>2 Private Subnets</li><li>2 Public Subnets</li><li>Elastic IP</li><li>Internet Gateway</li><li>NAT Gateway</li><li>Public Route Table</li><li>Private Route Table</li><li>Load Balancer Security Group(Port 80)</li><li>Application Security Group(Port 8080)</li></ul>_ | Set the foundation to deploy our application infrastructure onto |  ![vpc](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/vpc.PNG)    |   | 
|12. | _Create a listener for the load balancer_| To set the rules for the load balancer like which port to listen on, what to do with requests...| ![12](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/11.PNG)  |   |  
|13. | _Create a application load balancer_ | To route traffic based on certain requirements | ![13](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/12.PNG)  |   |
|14. | _Create a load balancer target group_ | To logically group resources together for the load balancer to route requests to (like web server group and application server group)| ![14](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/13.PNG) |   |
|15. | _Create a ECS cluster_ | For AWS to run our Docker containers | ![15](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/14.PNG)  |   |
|16. | _Create a ECS task(container)_ | For defining our containers configuration such as the image to build the container from, the ports to open on the container...| ![16](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/15.PNG)  |   |
|17. | _Create a ECS service_ | For defining our container context like what cluster/tasks definition we'll use, how many tasks and the load balancer we'll use to route our container traffic | ![17](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/16.PNG)  |   |
|18a. | _Terraform successfully deploys our infrastructure_| To continuiously deploy our containerized banking application in a private subnet, only available via our application load balancer URL | ![18](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/18a.PNG)  |  |
### _Successful Deployment_
<p align="center">
<img src="https://github.com/djtoler/Deployment7/blob/main/dp7_assets/dp7-alb.PNG">
</p>

---

## System Diagram


