#!/usr/bin/env bash

# while getopts :u:d:p:f: option
# do
# case "${option}"
# in
# u) USER=${OPTARG};;
# d) DATE=${OPTARG};;
# p) PRODUCT=${OPTARG};;
# f) FORMAT=$OPTARG;;
# esac
# done

python3 /home/md_user/transform.py
mkdocs build -v
linkchecker site/index.html
mv site public
