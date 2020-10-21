FROM python:3.8.6-slim

ENV TZ="Europe/Moscow"

# apt-get and system utilities
RUN apt-get update && apt-get install -y \
    locales curl apt-utils apt-transport-https debconf-utils gcc build-essential g++\
# adding custom MS repository
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -\
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list\
# install SQL Server drivers & utils
    && apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools unixodbc-dev libgssapi-krb5-2\
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile\
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc\
    && /bin/bash -c "source ~/.bashrc"\
# set locales
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen\
    && rm -rf /var/lib/apt/lists/*

RUN sed -i 's/TLSv1.2/TLSv1/g' /etc/ssl/openssl.cnf \
    && sed -i 's/SECLEVEL=2/SECLEVEL=1/g' /etc/ssl/openssl.cnf