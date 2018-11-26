#!/usr/bin/env bash

while getopts :mvl option; do
  case "${option}" in
    m)
      MODE=${OPTARG}
      echo "Mode is 'destruct_mode'"
      ;;
    v)
      VERBOSE="-v"
      ;;
    l)
      LINKCHECKER=true
      ;;
  esac
done

python3 /home/md_user/transform.py "$MODE"

mkdocs build "$VERBOSE"

if [ "$LINKCHECKER" = true ] ; then
  linkchecker site/index.html
fi

mv site public
