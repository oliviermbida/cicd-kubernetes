# cicd-kubernetes
[![CircleCI](https://dl.circleci.com/status-badge/img/gh/oliviermbida/cicd-kubernetes/tree/master.svg?style=svg&circle-token=333c1cba50d11f15beb73b20cb25cf30b6c40d18)](https://dl.circleci.com/status-badge/redirect/gh/oliviermbida/cicd-kubernetes/tree/master)
[![Build Status](https://dev.azure.com/oliviermbida/azure-jetson-autopilot-cicd/_apis/build/status/oliviermbida.cicd-kubernetes?branchName=master)](https://dev.azure.com/oliviermbida/azure-jetson-autopilot-cicd/_build/latest?definitionId=3&branchName=master)

# Continuous Integration (CI)
-----------------------------------

Commit build triggers: 

Trigger Circleci: `[skip azp][Circleci]`

Default: Azure CI pipeline

Skip all CI build: `[skip azp]`

# [AzureBuild]

`azure-pipelines.yml`

Prerequisites:

 . Agent pool
 
![Agent pool](/docs/images/agent_pool.png)
 
Self-hosted agents :
 
 mydockeragent : `agent/Dockerfile`
 
Build: `docker build -t dockeragent:latest .`
  
Run: `docker run -e AZP_URL=https://dev.azure.com/{$USERNAME}/ -e AZP_TOKEN=<PAT token> -e AZP_AGENT_NAME=mydockeragent dockeragent:latest`
 
If you require docker in a docker container you can use this:
 
Run: `docker run -v /var/run/docker.sock:/var/run/docker.sock -e AZP_URL=https://dev.azure.com/{$USERNAME}/ -e AZP_TOKEN=<PAT token> -e AZP_AGENT_NAME=mydockeragent dockeragent:latest`
  
Follow the instructions in the link below to run a linux machine agent:
  
 [Azure linux agent](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops)
  
Configure: `./config.sh --unattended --url <url> --auth pat --token <token> --pool <pool> --agent <agent> --replace --work <workDirectory> --acceptTeeEula`

# Miscellaneous

For local testing:

`make all`

This will setup a devops virtual environment , install the linters and run lint.

`make validate-circleci`

This will validate your configuration in `.circleci/config.yml`

See `Makefile` for all the targets.

Manually verify format of Makefile:

`cat -e -t -v Makefile`

It shows the presence of tabs with ^I and line endings with $.
Each line of instructions should start with ^I and end with $.

# Continuous Deployment (CD)
-----------------------------------

Prerequisites:

For discovery.

Public Subnets Tags:

kubernetes.io/cluster/eks-cluster : shared or owned

kubernetes.io/role/elb : 1

`scripts/deploy_rds.sh` : postgres database used to test nodejs production environment.

`kubectl exec $(kubectl get pod -l app=notebook-acbd4e1 -o name | head -n 1) -- env`

![Envs inside pod](docs/images/Production_env_inside_pod.png)



