ARG VERSION=latest
FROM jare/emacs:$VERSION

RUN apt update && apt install sqlite3 libsqlite3-dev

# Change this date and rebuild to apt-upgrade
RUN echo "apt-upgrading today, 2020-06-09" && \
    apt update && apt upgrade -y

COPY .emacs.d /home/emacs/.emacs.d
