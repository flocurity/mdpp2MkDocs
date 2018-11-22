# This dockerfile builds the image needed to build a wiki from:
# - MarkdownPP
# - some personal tricks to repare broken links from templates
# - MkDocs

FROM python:3.7

LABEL name="mdpp2MkDocs" \
      description="Build MkDocs from MarkdownPP" \
      url="https://github.com/flocurity/mdpp2MkDocs" \
      maintainer="Florent Baillais <flocurity@gmail.com>"
# dependencies
ADD ./requirements.txt ./

RUN \
    useradd --create-home --shell /bin/bash md_user &&\
    # install linkchecker (not compatible with python3 ==> use apt)
    apt install -y linkchecker --no-install-recommends &&\
    rm -rf /var/lib/apt/lists/* &&\
    # install requirements
    pip3 install --no-cache-dir -r ./requirements.txt

USER md_user

# MarkdownPP for CI
ADD ./transform.py ./transform.py
# links processors
ADD ./update_links.py ./update_links.py

# fix permissions
RUN \
    chmod u+x transform.py &&\
    chmod u+x update_links.py

# start zap with environment variables
# ENTRYPOINT python3 zap2gitlab_main.py
