
Author : KHAJA EHTESHAMUDDIN AHMED

This Repo illustrates to help us with setting the Apache Web Server using terraform on AWS CLOUD.

Steps are available in reference IAC file VM-Provision-AWS.iac which is used as Scripted Pipeline.


Configuring Jenkins
To configure AWS credentials in Jenkins:

On the Jenkins dashboard, go to Manage Jenkins > Manage Plugins in the Available tab. Search for the Pipeline: AWS Steps plugin and choose Install without restart.
Navigate to Manage Jenkins > Manage Credentials > Jenkins (global) > Global Credentials > Add Credentials.

Select the option AWS Credentials for AWS credentials configuration in Jenkins as below.
<img width="1467" alt="image" src="https://github.com/ehteshamkhaja/ec2-instance-creation-using-terraform/assets/27899831/a8779b05-5c59-432c-aec3-e03422bb4d73">


Next, Add the GIT credentials in Jenkins ( first create the token in the Git)
Select the option as 'Username and Password' and provide username as email id and password as Token generated in GIT.
<img width="1208" alt="image" src="https://github.com/ehteshamkhaja/ec2-instance-creation-using-terraform/assets/27899831/a5a2a562-da21-47fb-998b-962d1d6b3159">

Use Project as "Pipeline" and provide the VM-Provision-AWS.iac , provide the below parameters to the pipeline

ENV-master, branch-master,Approval -> --auto-approve, action -> apply,destroy, GITURL --> https://github.com/ehteshamkhaja/ec2-terraform-ansible.git