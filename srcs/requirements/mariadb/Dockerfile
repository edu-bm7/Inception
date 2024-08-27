FROM debian:bullseye

# Set DEBIAN_FRONTEND to noninteractive to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    expect \
    && apt-get clean

COPY ./tools/entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld

EXPOSE 3306

ENTRYPOINT [ "/bin/bash", "/usr/local/bin/entrypoint.sh" ]