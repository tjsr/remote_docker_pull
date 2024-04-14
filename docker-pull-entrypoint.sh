#!/bin/sh
set -eu

if [ -z "$INPUT_REMOTE_DOCKER_USER" ]; then
  echo "Input REMOTE_DOCKER_USER is required!"
  exit 1
fi

if [ -z "$INPUT_REMOTE_DOCKER_HOST" ]; then
  echo "Input REMOTE_DOCKER_HOST is required!"
  exit 1
fi

if [ -z "$INPUT_SSH_PRIVATE_KEY" ]; then
  echo "Input SSH_PRIVATE_KEY is required!"
  exit 1
fi

if [ -z "$INPUT_DOCKER_IMAGE" ]; then
  echo "Input DOCKER_IMAGE is required!"
  exit 1
fi

INPUT_REMOTE_DOCKER_PORT="${INPUT_REMOTE_DOCKER_PORT:=22}"

mkdir -p ~/.ssh

echo "$INPUT_SSH_PRIVATE_KEY" >~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

ssh-keyscan -p $INPUT_REMOTE_DOCKER_PORT "$INPUT_REMOTE_DOCKER_HOST" >>~/.ssh/known_hosts 2>/dev/null
ssh-keyscan -p $INPUT_REMOTE_DOCKER_PORT "$INPUT_REMOTE_DOCKER_HOST" >>/etc/ssh/ssh_known_hosts 2>/dev/null

eval $(ssh-agent) 2>&1 >/dev/null
ssh-add ~/.ssh/id_rsa 2>/dev/null

DOCKER_COMMAND="docker --host=ssh://ec2-user@$INPUT_REMOTE_DOCKER_HOST:$INPUT_REMOTE_DOCKER_PORT"

${DOCKER_COMMAND} pull ${INPUT_DOCKER_IMAGE}

if [ ! -z "${INPUT_LOCAL_TAG-}" ]; then
  ${DOCKER_COMMAND} tag ${INPUT_DOCKER_IMAGE} ${INPUT_LOCAL_TAG}
fi
