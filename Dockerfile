FROM phusion/baseimage:0.9.17
MAINTAINER Sebastian Ruml <sebastian@sebastianruml.name>

ENV HOME /root
CMD ["/sbin/my_init"]
EXPOSE 80

# All our dependencies, in alphabetical order (to ease maintenance)
RUN apt-get update -q
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    curl \
    mysql-client \
    nginx \
    php5-common \
    php5-curl \
    php5-fpm \
    php5-gd \
    php5-intl \
    php5-imagick \
    php5-ldap \
    php5-mcrypt \
    php5-mysql \
    php5-pgsql \
    php5-sqlite \
    unzip \
    wget

# Common environment variables
ENV SELFOSS_VERSION=2.14

# Add run scripts
RUN mkdir /etc/service/nginx
ADD runit/nginx.sh /etc/service/nginx/run
RUN chmod a+x /etc/service/nginx/run

RUN mkdir /etc/service/php5-fpm
ADD runit/php5-fpm.sh /etc/service/php5-fpm/run
RUN chmod a+x /etc/service/php5-fpm/run

# Add configs
ADD config/nginx.conf /etc/nginx/nginx.conf
ADD config/nginx-default.conf /etc/nginx/sites-available/default
ADD config/php.ini /etc/php5/fpm/php.ini

ADD scripts/init-selfoss.sh /etc/my_init.d/05-nginx.sh
RUN chmod a+x /etc/my_init.d/05-nginx.sh

ADD https://github.com/SSilence/selfoss/releases/download/$SELFOSS_VERSION/selfoss-$SELFOSS_VERSION.zip /tmp/
RUN mkdir -p /usr/share/nginx/html
RUN unzip /tmp/selfoss-$SELFOSS_VERSION.zip -d /usr/share/nginx/html
RUN rm /tmp/selfoss-$SELFOSS_VERSION.zip
ADD config/selfoss-config.ini /usr/share/nginx/html/config.ini
RUN chown -R www-data:www-data /usr/share/nginx/html
RUN chmod 775 /usr/share/nginx/html/data/cache /usr/share/nginx/html/data/favicons /usr/share/nginx/html/data/logs /usr/share/nginx/html/data/thumbnails /usr/share/nginx/html/data/sqlite /usr/share/nginx/html/public/

# add cron job
ADD config/crontab /etc/cron.d/selfoss-cron
RUN chmod 0644 /etc/cron.d/selfoss-cron

# Disable ssh
RUN touch /etc/service/sshd/down

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
