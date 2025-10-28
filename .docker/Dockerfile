FROM php:8.2-fpm

# Arguments defined in docker-compose.yml
ARG WWWUSER
ARG WWWUID

WORKDIR /var/www/html

# Install system dependencies and clear cache
RUN apt-get -y update \
    && apt-get install -y \
    libfreetype6-dev \
    libpq-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libxml2-dev \
    libgmp-dev \
    libzip-dev \
    zip \
    unzip \
    curl \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) iconv gd mysqli pdo_pgsql pdo_mysql soap bcmath gmp intl opcache zip

# Install Xdebug
RUN pecl install xdebug 3.2.2

RUN mkdir -p /var/log && \
    touch /var/log/xdebug.log && \
    chmod 666 /var/log/xdebug.log


# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $WWWUID -d /home/$WWWUSER $WWWUSER
RUN mkdir -p /home/$WWWUSER/.composer && \
    chown -R $WWWUSER:$WWWUSER /home/$WWWUSER

USER $WWWUSER
