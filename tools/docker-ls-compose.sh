#!/bin/bash

BASE_DIR="${KOTOOLS_DIR}/docker"
# cd `dirname $0`

showDescription() {
  cat <<EOD
  shows list of docker-compose files without file extention
  
  Parameters
    -h -help   <Optional>    shows descriptions
  
  USAGE
    docker-ls-compose.sh <OPTIONS>
  
  EXAMPLES
    docker-ls-compose.sh
EOD
}

listUp() {
    local YML_EXTENTION='.yml'
    for file in $(ls $BASE_DIR/compose); do
        echo ${file%$YML_EXTENTION}
    done
}

while getopts ":h" opt; do
    case "$opt" in
        h | help )
          showDescription
          exit 1
          ;;
        * )
          echo "Invalid Option: -${OPTARG}" 1>&2
          exit 1
          ;;
    esac
done
shift $((OPTIND -1))

listUp
