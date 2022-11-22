# Commands to build and run nginx
# docker build -t <image name> nginx 
# docker run -p 2080:2080 <image name>

# Build openssl image to fix nginx init issue
ARG ARTIFACTORY_REMOTE=

FROM ${ARTIFACTORY_REMOTE}nginx:1.17.4
ENV DEBIAN_FRONTEND noninteractive

COPY *.deb /tmp/
RUN apt update; \
	apt install -y libssl1.1 openssl /tmp/*$(uname -m | sed -e 's/x86_64/amd64/').deb;

RUN ldconfig

# Update openssl engine configure
COPY openssl.cnf /etc/ssl/openssl.cnf

# Add nginx configure file, add 2080 port for test; add new html welcome file
COPY ssleng.index.html /usr/share/nginx/html
#nginx needs to explicitly setup which environment variables are allowed
COPY nginx.conf.gig /tmp/nginx.conf
RUN  mv /tmp/nginx.conf /etc/nginx/nginx.conf
COPY *.conf /etc/nginx/conf.d/

# start.sh create new certificate in cert folder and key when running docker run
RUN  mkdir -p /etc/nginx/cert
COPY start.sh /usr/sbin/
RUN chmod +x /usr/sbin/start.sh

# nginx testing port: 80 for http, 2080 for https (via openssl engine)
EXPOSE 2080/tcp 80/tcp

CMD ["start.sh"]
