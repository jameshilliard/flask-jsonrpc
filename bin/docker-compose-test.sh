#!/bin/bash

DOCKER_COMPOSE_FILE_NAME=docker-compose.test.yml
DOCKER_COMPOSE_FILE_PATH=../${DOCKER_COMPOSE_FILE_NAME}
[ -f ${DOCKER_COMPOSE_FILE_PATH} ] || DOCKER_COMPOSE_FILE_PATH=${DOCKER_COMPOSE_FILE_NAME}

docker-compose -f ${DOCKER_COMPOSE_FILE_PATH} -p ci build --build-arg VERSION=$(date +%s)
docker-compose -f ${DOCKER_COMPOSE_FILE_PATH} -p ci up -d

DOCKER_WAIT_FOR_PY36=$(docker wait ci_python3.6_1)
docker logs ci_python3.6_1

DOCKER_WAIT_FOR_PY37=$(docker wait ci_python3.7_1)
docker logs ci_python3.7_1

DOCKER_WAIT_FOR_PY38=$(docker wait ci_python3.8_1)
docker logs ci_python3.8_1

DOCKER_WAIT_FOR_PY39=$(docker wait ci_python3.9_1)
docker logs ci_python3.9_1

DOCKER_WAIT_FOR_PY310=$(docker wait ci_python3.10_1)
docker logs ci_python3.10_1

docker-compose -f ${DOCKER_COMPOSE_FILE_PATH} -p ci down

if [ ${DOCKER_WAIT_FOR_PY36} -ne 0 ]; then echo "Test to Python 3.6 failed"; exit 1; fi
if [ ${DOCKER_WAIT_FOR_PY37} -ne 0 ]; then echo "Test to Python 3.7 failed"; exit 1; fi
if [ ${DOCKER_WAIT_FOR_PY38} -ne 0 ]; then echo "Test to Python 3.8 failed"; exit 1; fi
if [ ${DOCKER_WAIT_FOR_PY39} -ne 0 ]; then echo "Test to Python 3.9 failed"; exit 1; fi
if [ ${DOCKER_WAIT_FOR_PY310} -ne 0 ]; then echo "Test to Python 3.10 failed"; exit 1; fi
