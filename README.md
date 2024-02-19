o	Repository Files’ description:
  • AnsiblePlaybooks (Folder): This folder contains both the playbooks and the configuration files to dynamically inventory the ansible nodes deployed on AWS EC2.
    +	DeployOnDocker-Playbook.yml: This playbook creates the Docker container based on the image pulled from the Docker Registry and publishes the app on port TCP-80
        							 by mapping the port 8081 that the app uses to the host port 80.
    +	DockerCleanUp-Playbook.yml: This playbook reset the image and the containers by removing them to avoid conflicts or errors if the code is built again.
    +	ansible.cfg: This file contains the default parameters used by ansible, and the AWS plugins to work with the dynamic inventory.
        			 These parameters can be override by explicit commands either inside the playbooks or passing them directly to ad-hoc commands.
    +	ansiworkers.aws_ec2.yml: This file is used for the AWS plug-in to use dynamic inventory on AWS.
    
  • Code (Folder): This folder contains the source code that needs to be compiled and packaged to be later be build as a Docker image.
    + Logs (Folder): This folder was created to push the output of the maven tasks (verify, compile, test, package) into files for be reviewed after execution.
                     The files are override on each execution.
    + src (Folder): This folder contains the actual source code for the application.
    + mvnw & mvnw.cmd: These files are required in case maven is not installed in the host or is not found in the PATH.
                       For our case will remain there but won’t be necessary as the Maven Jenkins plugin can accomplish the same task.
    + pom.xml: This file contains information about the project and configuration details used by Maven to build the project.

  • TerraformInfra (Folder): this folder contains all the files required to deploy the ansible nodes in AWS. 
    + main.tf: This file contains the main code to plan, apply and destroy the AWS infrastructure.
               The resources will be defined here, and they will call for the variables in the other files.
    + variable.tf: this file contains the variable definitions and its default values when needed.
                   These variables will be set depending on the infrastructure to build and will be read by the main.tf file.
    + ansiblelab.tfvars: this file contains the values to be associated to the variables to deploy a development environment.

  •	.gitignore: this file contains the expressions that allows to exclude the track and versioning of folders or files in Git.

  •	Dockerfile: this file contains the directives to build the Docker Image.

  •	Jenkinsfile: This file contains all the directives for the actual Jenkins pipeline that will oversee the CI/CD.
