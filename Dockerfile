FROM amazonlinux:2
LABEL MAINTAINER="Yuya Ito <i.yuuya@gmail.com>"

# install packages
RUN amazon-linux-extras install php7.2 \
 && yum install -y \
      php \
      php-json \
      php-mbstring \
      php-gd \
      php-mysqlnd \
      php-opcache \
      php-xml \
      git \
      httpd \
      httpd-tools \
      https://cdn.mysql.com/archives/mysql-5.6/MySQL-shared-5.6.42-1.el7.x86_64.rpm \
      https://cdn.mysql.com/archives/mysql-5.6/MySQL-shared-compat-5.6.42-1.el7.x86_64.rpm \
      https://cdn.mysql.com/archives/mysql-5.6/MySQL-devel-5.6.42-1.el7.x86_64.rpm \
      https://cdn.mysql.com/archives/mysql-5.6/MySQL-client-5.6.42-1.el7.x86_64.rpm \
 && rm -rf /var/cache/yum/* \
 && yum clean all

# install composer
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# configuration apache
RUN ( \
    echo '<VirtualHost *:80>' \
 && echo '  ServerName drupal.test' \
 && echo '  DocumentRoot "/data/drupal/web"' \
 && echo '' \
 && echo '  <Directory /data/drupal/web>' \
 && echo '    Options +Indexes +FollowSymLinks -MultiViews' \
 && echo '    AllowOverride All' \
 && echo '    Order allow,deny' \
 && echo '    Allow from all' \
 && echo '    Require all granted' \
 && echo '  </Directory>' \
 && echo '</VirtualHost>' \
    ) >> /etc/httpd/conf.d/druapl.conf

RUN mkdir -p /data
WORKDIR /data/drupal

EXPOSE 80
CMD ["httpd", "-D", "FOREGROUND"]
