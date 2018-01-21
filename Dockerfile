FROM composer:latest AS composer

COPY typo3 /app

RUN composer install --no-ansi --no-interaction --no-dev --no-progress --classmap-authoritative

RUN vendor/bin/typo3cms install:generatepackagestates \
    && vendor/bin/typo3cms install:fixfolderstructure \
    && mkdir configuration \
    && ln -s ../../configuration/LocalConfiguration.php web/typo3conf/LocalConfiguration.php \
    && ln -s ../../configuration/AdditionalConfiguration.php web/typo3conf/AdditionalConfiguration.php \
    && ln -s ../../configuration/AdditionalFactoryConfiguration.php web/typo3conf/AdditionalFactoryConfiguration.php \
    && ln -s ../../configuration/realurl_conf.php web/typo3conf/realurl_conf.php

FROM t3easy/php:7.1

ENV TYPO3_CONTEXT Development

COPY --chown=www-data:www-data --from=composer /app .
