#!/usr/bin/env bash


# Function: Print a help message.
usage() {
  echo "Usage: $0 [ -m MODE ] [ -v ] [ -l ] [ -u ]" 1>&2
  echo "[ -m MODE ] : supported mode => destruct_mode => delete mdpp files before publishing. For CI only " 1>&2
  echo "[ -v ] : set mkdocs to verbose mode - for debugging only" 1>&2
  echo "[ -l ] : use linkchecker to check for broken links" 1>&2
  echo "[ -u ] : see for yourself !" 1>&2
}

# Function: Exit with error.
exit_abnormal() {
  usage
  exit 1
}

while getopts m:vluh option; do
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
    :)
      echo "Error: -${OPTARG} requires an argument."
      usage
      exit 42
      ;;
    *)
      usage
      exit 42
      ;;
  esac
done

python3 /home/md_user/transform.py $MODE

mkdocs build $VERBOSE

if [ "$LINKCHECKER" = true ] ; then
  linkchecker site/index.html
fi

mv site public
