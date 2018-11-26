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

ADD ./files ./

# fix permissions
RUN \
    # Orchestrator
    chown md_user:md_user ./*.sh &&\
    chmod u+x ./*.sh &&\
    # MarkdownPP for CI && links processors
    chown md_user:md_user ./*.py &&\
    chmod u+x ./*.py

USER md_user
