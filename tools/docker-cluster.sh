#!/bin/bash

BASE_DIR="${KOTOOLS_DIR}/docker"
COMPOSE_ACTIONS=("up" "down")
COMPOSE_ACTION="up"
DOCKER_COMPOSE_FILES=""
# cd `dirname $0`

showDescription() {
  cat <<EOD
  docker compose cluster up or down script.
  you can simply cluster up or down together. 
  
  Parameters
    -h --help   <Optional>    shows descriptions
    -f --file   <Required>    list of docker-compose.yml file names with comma delimeters
                              if there are docker-base,yml, jenkins,yml and redis.yml. You can command like the below. 
                              ex) -f docker-base,jenkins,redis
    -a --action <Optional>    up or down compose action.
                              default is up.
  
  USAGE
    docker-cluster.sh <OPTIONS>
  
  EXAMPLES
    docker-cluster.sh -f docker-base,plantuml
    docker-cluster.sh -a up -f docker-base,plantuml
    docker-cluster.sh -a down -f docker-base,plantuml
EOD
}

makeComposeFileArgs() {
  for arg in ${1//,/ }; do
    DOCKER_COMPOSE_FILES+="--file ${arg}.yml "
  done
  DOCKER_COMPOSE_FILES=${DOCKER_COMPOSE_FILES%% }
  # echo ${DOCKER_COMPOSE_FILES}
}

validateComposeAction() {
  [ -z "$1" ] && echo "--action parameter is required" && exit 1

  for action in ${COMPOSE_ACTIONS[@]}; do
    [ "$action" == "$1" ] && return;
  done

  echo "Not allowed action: ${1}" && exit 1
}

execute() {
  local CMD="docker-compose ${1} ${2}"
  [ "${2}" == "${COMPOSE_ACTIONS[0]}" ] && CMD+=" --detach"
  echo $CMD
  $CMD
}

while getopts ":h:f:a:" opt; do
    case $opt in
        f | -file )
          makeComposeFileArgs $OPTARG
          ;;
        a | -action )
          validateComposeAction $OPTARG
          COMPOSE_ACTION=$OPTARG
          ;;
        h | -help)
          showDescription
          exit
          ;;
        \? )
          echo "Invalid Option: -${OPTARG}" 1>&2
          exit 1
          ;;
    esac
done
# shift $((OPTIND -1))

cd $BASE_DIR/composes
execute "$DOCKER_COMPOSE_FILES" "$COMPOSE_ACTION"
