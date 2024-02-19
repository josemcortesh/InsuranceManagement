 Repository Files’ description:

o	AnsiblePlaybooks (Folder): This folder contains both the playbooks and the  configuration files to dynamically inventory the ansible nodes deployed on AWS EC2.

    o	DeployOnDocker-Playbook.yml: This playbook creates the Docker container based on the image pulled from the Docker Registry
                                   and publishes the app on port TCP-80 by mapping the port 8081 that the app uses to the host port 80.
    o	DockerCleanUp-Playbook.yml: this playbook reset the image and the containers by removing them to avoid conflicts or errors if the code is built again.
    o	ansible.cfg: This file contains the default parameters used by ansible, and the AWS plugins to work with the dynamic inventory.
                   These parameters can be override by explicit commands either inside the playbooks or passing them directly to ad-hoc commands.
    o	ansiworkers.aws_ec2.yml: This file is used for the AWS plug-in to use dynamic inventory on AWS.
