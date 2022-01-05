#!/usr/bin/env bats
load "helpers/tests"
load "helpers/docker"
load "helpers/dataloaders"

load "lib/batslib"
load "lib/output"

export BATS_ELASTICDUMP_VERSION="${ELASTICDUMP_VERSION:-6.76.0}"

export BATS_ELASTICMS_TOOLBOX_DOCKER_IMAGE_NAME="${ELASTICMS_TOOLBOX_DOCKER_IMAGE_NAME:-docker.io/elasticms/toolbox:latest}"

@test "[$TEST_FILE] Running certinfo test command" {
  run docker run --rm ${BATS_ELASTICMS_TOOLBOX_DOCKER_IMAGE_NAME} certinfo -version
  assert_output -l -r "^dev$"
}

@test "[$TEST_FILE] Running elasticdump test command" {
  run docker run --rm ${BATS_ELASTICMS_TOOLBOX_DOCKER_IMAGE_NAME} elasticdump --version
  assert_output -l -r "^${BATS_ELASTICDUMP_VERSION}$"
}