# cicd-kubernetes
[![CircleCI](https://dl.circleci.com/status-badge/img/gh/oliviermbida/cicd-kubernetes/tree/master.svg?style=svg&circle-token=333c1cba50d11f15beb73b20cb25cf30b6c40d18)](https://dl.circleci.com/status-badge/redirect/gh/oliviermbida/cicd-kubernetes/tree/master)
[![Build Status](https://dev.azure.com/oliviermbida/azure-jetson-autopilot-cicd/_apis/build/status/oliviermbida.cicd-kubernetes?branchName=master)](https://dev.azure.com/oliviermbida/azure-jetson-autopilot-cicd/_build/latest?definitionId=3&branchName=master)

# Continuous Integration (CI)
-----------------------------------

Commit build triggers: 

Trigger Circleci: `[skip azp][Circleci]`

Trigger AWS CodeBuild: `[skip azp][CodeBuild]`

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

