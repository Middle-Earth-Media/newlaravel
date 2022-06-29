FROM middleearthmedia/php-8.0-alpine-latest

USER nobody

COPY --chown=nobody.nobody app /var/www/html/app
COPY --chown=nobody.nobody bootstrap /var/www/html/bootstrap
#COPY --chown=nobody.nobody config /var/www/html/config
COPY --chown=nobody.nobody public /var/www/html/public
COPY --chown=nobody.nobody resources /var/www/html/resources
COPY --chown=nobody.nobody routes /var/www/html/routes
COPY --chown=nobody.nobody storage /var/www/html/storage
COPY --chown=nobody.nobody vendor /var/www/html/vendor
COPY --chown=nobody.nobody database /var/www/html/database
COPY --chown=nobody.nobody artisan /var/www/html/artisan
COPY --chown=nobody.nobody composer.json /var/www/html/composer.json
