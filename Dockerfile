#########
# WHY ? #
#########

# This dockerfile builds the image needed to build a wiki from:
# - MarkdownPP
# - some personal tricks to repare broken links from templates
# - MkDocs

FROM python:3.7

LABEL name="mdpp2MkDocs" \
      description="Build MkDocs from MarkdownPP" \
      url="https://github.com/flocurity/mdpp2MkDocs" \
      maintainer="Florent Baillais <flocurity@gmail.com>"

####################
## LAYER : APT-GET #
####################

# install linkchecker from apt-get (not compatible with python3)
RUN \
    apt-get update &&\
    apt-get install -y linkchecker --no-install-recommends &&\
    rm -rf /var/lib/apt/lists/*

################
## LAYER : PIP #
################

# dependencies
ADD ./requirements.txt ./

# install requirements
RUN \
    pip3 install --no-cache-dir -r ./requirements.txt &&\
    useradd --create-home --shell /bin/bash md_user

#########################
## LAYER : PYTHON FILES #
#########################

WORKDIR /home/md_user

# Orchestrator
ADD ./transform.sh ./transform.sh
# MarkdownPP for CI
ADD ./transform.py ./transform.py
# links processors
ADD ./update_links.py ./update_links.py

# fix permissions
RUN \
    chown md_user:md_user ./transform.sh &&\
    chmod u+x ./transform.sh &&\
    chown md_user:md_user ./transform.py &&\
    chmod u+x ./transform.py &&\
    chown md_user:md_user ./update_links.py &&\
    chmod u+x ./update_links.py

USER md_user
