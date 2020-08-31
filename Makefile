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
	@if [ "${${*}}" = "" ]; then \
		echo -e "\e[91mEnvironment variable $* not set" 1>&2; exit 1;\
	fi

.PHONY: staging-release
git_sha?=HEAD
staging-release: guard-name guard-version ## prepare github URL for staging version `make staging-release name=SPRINTNAME version=X (git_sha=OPTIONAL_SHA)
	@if [ "$(shell git rev-parse --abbrev-ref HEAD)" != "master" ]; then\
		echo -e "\e[91mcurrent branch is not master branch, staging forbidden."; exit 1;\
	else\
		echo "master branch detected, preparing for staging...";\
	fi
	@latest_tag=$(shell git describe --match="staging_*" --abbrev=0 --tags); \
	echo "getting logs between $$latest_tag and $(git_sha)"; \
	logs=$$(git log $$latest_tag..$(git_sha) --pretty="format:- %s");\
	body=$$(scripts/url-encoder.bash $$logs);\
	echo -e "Open the following link to create the staging release:";\
	echo -e "\e[32mhttps://github.com/itisfoundation/osparc-simcore/releases/new?prerelease=1&target=$${git_sha}&tag=staging_$${name}$${version}&title=Staging%20$${name}$${version}&body=$${body}"
