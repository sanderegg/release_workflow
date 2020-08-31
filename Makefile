service=release_workflows

build:
	docker build -t local/$(service):production --label=$(shell git rev-parse --short HEAD) .

tag-version:
	docker tag local/$(service):production ${DOCKER_REGISTRY}/$(service):${DOCKER_IMAGE_TAG}

tag-local:
	docker tag ${DOCKER_REGISTRY}/$(service):${DOCKER_IMAGE_TAG} local/$(service):production

pull-version:
	docker pull ${DOCKER_REGISTRY}/$(service):${DOCKER_IMAGE_TAG}

push-version: tag-version
	docker push ${DOCKER_REGISTRY}/$(service):${DOCKER_IMAGE_TAG}

push-cache:
	# I don't care

info-images:
	# I don't care
.guard-%:
	@if [ "${${*}}" = "" ]; then \
		echo -e "\e[91mEnvironment variable $* not set" 1>&2; exit 1;\
	fi

staging_prefix := staging_
git_sha ?= HEAD
_git_get_current_branch = $(shell git rev-parse --abbrev-ref HEAD)
_git_get_latest_staging_tags = $(shell git describe --match="$(staging_prefix)*" --abbrev=0 --tags)
_git_get_pretty_logs = $(shell git log $(_git_get_latest_staging_tags)..$(_git_sha) --pretty="format:- %s")
_url_encode = $(shell scripts/url-encoder.bash "$(_git_get_pretty_logs)")
_git_get_repo_orga_name = $(shell git config --get remote.origin.url | grep --perl-regexp --only-matching "((?<=git@github\.com:)|(?<=https:\/\/github\.com\/))(.*?)(?=.git)")
.PHONY: .check-master-branch
.check-master-branch:
	@if [ "$(_git_get_current_branch)" != "master" ]; then\
		echo -e "\e[91mcurrent branch is not master branch."; exit 1;\
	fi

.PHONY: staging-release
staging-release: .check-master-branch .guard-name .guard-version ## prepare github URL for staging version `make staging-release name=SPRINTNAME version=X (git_sha=OPTIONAL_SHA)
	@echo "\e[33mOpen the following link to create the staging release:";
	@echo "\e[32mhttps://github.com/$(_git_get_repo_orga_name)/releases/new?prerelease=1&target=$(git_sha)&tag=staging_$(name)$(version)&title=Staging%20$(name)$(version)&body=$(_url_encode)";
