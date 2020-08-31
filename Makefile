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
guard-%:
	@ if [ "${${*}}" = "" ]; then \
			echo "Environment variable $* not set"; \
			exit 1; \
	fi

.PHONY: staging-release
staging-release: guard-name guard-version ## prepare github URL for staging version `make staging-release name=SPRINTNAME version=X (git_sha=OPTIONAL_SHA)
# check we are on master
	@if [ "$(git rev-parse --abbrev-ref HEAD)" != "master" ]; then\
		echo "this is not master branch, staging forbidden."; \
		exit 1;\
	fi
ifeq ($(git_sha),)
else
	git_sha=HEAD
endif
	git log
