FROM alpine:3.16
LABEL Maintainer="Joey Stowe<jbstowe@ua.edu>"
LABEL Description="Lightweight container with Nginx 1.20 & PHP 8.0 based on Alpine Linux."

# Install packages and remove default server definition
RUN apk -U upgrade && apk --no-cache add \
  build-base \
  curl \
  nginx \
  php8 \
  php8-ctype \
  php8-curl \
  php8-dom \
  php8-dev \
  php8-fileinfo \
  php8-fpm \
  php8-gd \
  php8-intl \
  php8-json \
  php8-mbstring \
  php8-mysqli \
  php8-opcache \
  php8-openssl \
  php8-phar \
  php8-pdo \
  php8-pdo_mysql \
  php8-session \
  php8-simplexml \
  php8-tokenizer \
  php8-xml \
  php8-xmlreader \
  php8-xmlwriter \
  php8-zlib \
  php8-zip \
  supervisor

# Create symlink so programs depending on `php` still function
RUN rm /usr/bin/php
RUN rm /usr/bin/phpize
RUN rm /usr/bin/php-config
RUN ln -s /usr/bin/php8 /usr/bin/php
RUN ln -s /usr/bin/phpize8 /usr/bin/phpize
RUN ln -s /usr/bin/php-config8 /usr/bin/php-config

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php8/php-fpm.d/www.conf
COPY config/php.ini /etc/php8/conf.d/custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install Composer 
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

#Switch back to PHP as the default
RUN rm /usr/bin/php && ln -s /usr/bin/php8 /usr/bin/php
RUN rm /usr/bin/phpize && ln -s /usr/bin/phpize8 /usr/bin/phpize
RUN rm /usr/bin/php-config && ln -s /usr/bin/php-config8 /usr/bin/php-config

# Setup document root
RUN mkdir -p /var/www/html

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /usr/bin && \
  chown -R nobody.nobody /var/log/nginx

# Add ability to run tinker
RUN mkdir /.config && \
    chmod -R 777 /.config

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Switch to use a non-root user from here on
USER nobody

# Add application
WORKDIR /var/www/html

# Expose the port nginx is reachable on
EXPOSE 8080

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
#HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping
