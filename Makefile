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
prod_prefix := v
_git_get_current_branch = $(shell git rev-parse --abbrev-ref HEAD)
# NOTE: be careful that GNU Make replaces newlines with space which is why this command cannot work using a Make function
_url_encoded_title = $(if $(findstring -staging, $@),Staging%20$(name),)$(version)
_url_encoded_tag = $(if $(findstring -staging, $@),$(staging_prefix)$(name),$(prod_prefix))$(version)
_url_encoded_target = $(if $(git_sha),$(git_sha),master)
define _url_encoded_logs
$(shell \
	scripts/url-encoder.bash \
	"$$(git log \
		$$(git describe --match="$(if $(findstring -staging, $@),$(staging_prefix),$(prod_prefix))*" --abbrev=0 --tags)..$(if $(git_sha),$(git_sha),HEAD) \
		--pretty=format:"- %s")"\
)
endef
define check_release_precond
$(if $(findstring -staging, $@),\
	if [ "${${name}}" = "" ]; then echo "\e[91mname of staging release is not set!"; exit 1; fi; \
	if [ "${${version}}" = "" ]; then echo "\e[91mversion of staging release is not set!"; exit 1; fi \
,\
	if [ "${${version}}" = "" ]; then echo "\e[91mname of staging version is not set!"; exit 1; fi \
)
endef
_git_get_repo_orga_name = $(shell git config --get remote.origin.url | \
							grep --perl-regexp --only-matching "((?<=git@github\.com:)|(?<=https:\/\/github\.com\/))(.*?)(?=.git)")

.PHONY: .check-master-branch
.check-master-branch:
	@if [ "$(_git_get_current_branch)" != "master" ]; then\
		echo -e "\e[91mcurrent branch is not master branch."; exit 1;\
	fi

.PHONY: release-staging release-prod
release-staging release-prod: .check-master-branch
	@echo "\e[33mOpen the following link to create the $(if $(findstring -staging, $@),staging,production) release:";
	@echo "\e[32mhttps://github.com/$(_git_get_repo_orga_name)/releases/new?prerelease=$(if $(findstring -staging, $@),1,0)&target=$(_url_encoded_target)&tag=$(_url_encoded_tag)&title=$(_url_encoded_title)&body=$(_url_encoded_logs)";
