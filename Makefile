service=release_workflows

build:
	docker build -t local/$(service):production .

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
