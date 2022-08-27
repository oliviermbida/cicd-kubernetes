setup:
	# Create python virtualenv & source it
	# source ~/.devops/bin/activate
	python3 -m venv ~/.devops

install:
	# This should be run from inside a virtualenv
	. ~/.devops/bin/activate
	@echo "---Installing prerequisites---"
	pip install --upgrade pip && \
		pip install -r requirements.txt
	sudo wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.16.3/hadolint-Linux-x86_64 && \
		sudo chmod +x /bin/hadolint
	@echo "---Linter installed---"
	cfn-lint --version
	pylint --version
	hadolint --version
install-circleci:
	. ~/.devops/bin/activate
	@echo "---Installing circleci cli---"
	curl -fLSs https://raw.githubusercontent.com/CircleCI-Public/circleci-cli/master/install.sh | sudo bash
	circleci version
	@echo "---Configure circleci cli---"
	@echo "Run : circleci setup"

validate-circleci:
	# See https://circleci.com/docs/2.0/local-cli/#processing-a-config
	. ~/.devops/bin/activate
	circleci config process .circleci/config.yml 

run-circleci-local:
	# See https://circleci.com/docs/2.0/local-cli/#running-a-job
	# chgrp -R git objects
	# chmod -R g+rws objects
	chmod -R 777 .git/objects
	circleci local execute 
build-app:
	# See https://circleci.com/docs/2.0/local-cli/#running-a-job
	chmod -R 777 .git/objects
	circleci local execute --job build-app
test:
	# Additional, optional, tests could go here
	#python -m pytest -vv --cov=myrepolib tests/*.py
	#python -m pytest --nbval notebook.ipynb

lint:
	. ~/.devops/bin/activate
	# See local hadolint install instructions:   https://github.com/hadolint/hadolint
	# This is linter for Dockerfiles
	hadolint Dockerfile 
	#agent/Dockerfile
	# This is a linter for Python source code linter: https://www.pylint.org/
	# This should be run from inside a virtualenv
	#pylint --disable=R,C,W1203,W1202 *.py
	# This is the linter for cloudformation
	cfn-lint *.yaml *.yml
clean:
	@if [ -f "~/.circleci/cli.yml" ]; then \
		rm -f ~/.circleci/cli.yml; \
	fi

all: setup install lint test