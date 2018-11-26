#!/usr/bin/env bash

while getopts :mvlu option; do
  case "${option}" in
    m)
      MODE=${OPTARG}
      echo "Mode is $MODE !"
      ;;
    v)
      VERBOSE="-v"
      ;;
    l)
      LINKCHECKER=true
      ;;
    u)
      cat /home/md_user/hidden_file
      ;;
  esac
done

python3 /home/md_user/transform.py $MODE

mkdocs build $VERBOSE

if [ "$LINKCHECKER" = true ] ; then
  linkchecker site/index.html
fi

mv site public
