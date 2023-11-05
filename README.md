## Deployment 7


|#|Step| Purpose  | Jenkinsfile  | Business Case  |
|---|---|---|---|---|
|1. |Jenkins controller tells Docker agent to start working the pipeline| Efficently handle workloads using a distributed system strategy  | ![1](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/1.PNG)   |   |
|2. |DockerHub credentials set in Jenkins enviornment| Authorization to programatically push Docker images to DockerHub  | ![2](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/2dockercreds.PNG)  |   |
|3. |Test application dependencies in virtual enviornment| Catch configuration drifts and errors in a controlled, isolated enviornment before build our Docker image  | ![3](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/3.PNG)  |   |
|4. |Build a Docker image of our banking application| Continuously intergrate application code changes into our Docker image  | ![4](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/4dockerfiledp7.PNG)  |   |
|5. |Programatically log into DockerHub account using credentials from step 2| Automate pushing Docker image to DockerHub repo    | ![5](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/5.PNG)  |   |
|6. | Push updated Docker image to DockerHub repo | Make the latest version of our applications Docker image available for download | ![6] (https://github.com/djtoler/Deployment7/blob/main/dp7_assets/6.PNG) |   |
|7.|  Jenkins controller tells Terraform agent to take over pipeline execution steps  | Leverage Jenkins distributed architecture to operate in a enviornment specifically configured for deploying AWS infrastructure   | ![7](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/7.PNG)  |   |
|8. | Run `terraform init` | Terraform sets up context to deploy resources in like providers, state files...| ![8](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/8.PNG)  |   |   
|9. | Run `terraform plan -out plan.tfplan`| Terraform compares current state of resources to our `.tf` files, makes a plan to deploy what we ask for and saves it to a file called `tfplan.tf` | ![9](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/9.PNG)  |   |
|10. | Run `terraform apply plan.tfplan`|Terraform attempts to deploy the resources saved in the `plan.tfplan` file from step 9| ![10](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/10.PNG) |   |   
|#|Step| Purpose  | Terraform  | Business Case  |
|11. | Create VPC, 2 Private Subnets, 2 Public Subnets, Elastic IP, Internet Gateway, Nat Gateway, Public Route Table, Private Route Table, Load Balancer Security Group, Application Security Group | Set the foundation to deploy our application infrastructure onto |  [VPC.tf](https://github.com/djtoler/Deployment7/blob/main/intTerraform/vpc.tf)    |   | 
|12. | Create a listener for the load balancer| To set the rules for the load balancer like which port to listen on, what to do with requests...| ![12](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/11.PNG)  |   |  
|13. | Create a application load balancer | To route traffic based on certain requirements | ![13](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/12.PNG)  |   |
|14. | Create a load balancer target group| To logically group resources together for the load balancer to route requests to (like web server group and application server group)| ![14](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/13.PNG) |   |
|15. | Create a ECS cluster | For AWS to run our Docker containers | ![15](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/14.PNG)  |   |
|16. | Create a ECS task(container)| For defining our containers configuration such as the image to build the container from, the ports to open on the container...| ![16](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/15.PNG)  |   |
|17. | Create a ECS service| For defining our container context like what cluster/tasks definition we'll use, how many tasks and the load balancer we'll use to route our container traffic | ![17](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/16.PNG)  |   |
|18a. | Terraform successfully deploys our infrastructure| To continuiously deploy our containerized banking application in a private subnet, only available via our application load balancer URL | ![18](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/18a.PNG)  |  |
|18b. | Our Terraform build fails and the `Apply` stage o four Jenkins pipeline fails | To inform us that something is wrong with our infrastructure configuration | ![18b](https://github.com/djtoler/Deployment7/blob/main/dp7_assets/18b.PNG)  | |
