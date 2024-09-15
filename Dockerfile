#----------------------------------------------------------------------
# frontaccounting - a FrontAccounting on Debian 10 Docker Container
#----------------------------------------------------------------------

FROM debian:10.13

#MAINTAINER Eugene F. Barker <genebarker@gmail.com>

# install dependencies
RUN apt-get update && apt-get install -y \
    apache2 \
    git \
    php7.3 \
    php7.3-mysql
RUN DEBIAN_FRONTEND=noninteractive apt-get install nullmailer

# get FrontAccounting from repository: genebarker/FA
# fork of the official: FrontAccountingERP/FA
RUN cd /root && \
    git clone https://github.com/FrontAccountingERP/FA.git

#    git clone https://github.com/genebarker/FA.git

# copy initial apache2 SSL key and cert
# (to make sure they are not used by --https and --hsts options)
# and move default index.html to empty webroot
RUN mkdir /root/oldfiles && \
    cd /root/oldfiles && \
    cp /etc/ssl/private/ssl-cert-snakeoil.key . && \
    cp /etc/ssl/certs/ssl-cert-snakeoil.pem . && \
    mv /var/www/html/index.html .

# set apache env variables
# note: apache SSL setup is configured at runtime via entrypoint.sh script
ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data
ENV APACHE_LOG_DIR=/var/log/apache2

# copy in entrypoint script
COPY ./entrypoint.sh /

# set the container's entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# expose default webapp ports
EXPOSE 80 443
