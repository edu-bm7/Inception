FROM debian:bullseye

# Set DEBIAN_FRONTEND to noninteractive to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
 	nginx \
	openssl \
	&& apt-get clean

RUN mkdir -p /etc/nginx/ssl/private
RUN mkdir -p /etc/nginx/ssl/certs

RUN openssl req -batch -x509 -sha256 -nodes -newkey rsa:2048 -days 365 \
		-keyout /etc/nginx/ssl/private/inception.key \
		-out /etc/nginx/ssl/certs/inception.crt \
		-subj "/C=BR/ST=SP/L=Ribeirao Pires/O=42SP/CN=ebezerra.42.fr"

COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
