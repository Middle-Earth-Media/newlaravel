FROM middleearthmedia/php-8.0-alpine-latest

USER nobody

COPY --chown=nobody app /var/www/html/app
COPY --chown=nobody bootstrap /var/www/html/bootstrap
COPY --chown=nobody config /var/www/html/config
COPY --chown=nobody public /var/www/html/public
COPY --chown=nobody resources /var/www/html/resources
COPY --chown=nobody routes /var/www/html/routes
COPY --chown=nobody storage /var/www/html/storage
COPY --chown=nobody vendor /var/www/html/vendor
COPY --chown=nobody database /var/www/html/database
COPY --chown=nobody artisan /var/www/html/artisan
COPY --chown=nobody composer.json /var/www/html/composer.json
