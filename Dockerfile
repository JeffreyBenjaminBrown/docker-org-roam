ARG VERSION=latest
FROM jare/emacs:$VERSION

RUN apt update && apt install sqlite3 libsqlite3-dev

# Change this date and rebuild to apt-upgrade
RUN echo "apt-upgrading today, 2020-06-09" && \
    apt update && apt upgrade -y

COPY .emacs .emacs.d /home/emacs/.emacs.d/

RUN mkdir /mnt/roam-data && \
    mkdir /mnt/misc

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Why doesn't this work? I still begin in /mnt/workspace
RUN rmdir /mnt/workspace
WORKDIR "/mnt"
