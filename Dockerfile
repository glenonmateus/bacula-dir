FROM debian:buster

ENV BACULA_VERSION 9.4.4
ENV DEBIAN_FRONTEND noninteractive
ENV TZ America/Sao_Paulo

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
	curl \
	ca-certificates \
	file \
	make \
	build-essential \
	postgresql-server-dev-11 \
	postgresql-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/bacula /var/lib/bacula /run/bacula /etc/bacula/scripts /var/log/bacula/ \
    && useradd -U -s /bin/sh -d /var/lib/bacula bacula \
    && curl -sL https://sourceforge.net/projects/bacula/files/bacula/${BACULA_VERSION}/bacula-${BACULA_VERSION}.tar.gz/download -o bacula-${BACULA_VERSION}.tar.gz \
    && tar xzf bacula-${BACULA_VERSION}.tar.gz && cd bacula-${BACULA_VERSION} \
    && ./configure \
	--enable-smartalloc \
	--sbindir=/usr/bin/ \
	--sysconfdir=/etc/bacula/ \
	--with-pid-dir=/run/bacula/ \
	--with-subsys-dir=/var/lib/bacula \
	--with-working-dir=/var/lib/bacula \
	--with-dir-user=bacula \
	--with-dir-group=bacula \
	--with-scriptdir=/etc/bacula/scripts \
	--enable-build-stored=no \
	--with-postgresql \
    && make && make install \
    && cd .. && rm -rf bacula-${BACULA_VERSION}*

COPY ["run", "/usr/local/bin/"]
COPY ["bconsole.conf", "/etc/bacula/"]
COPY ["bacula-dir.conf", "/etc/bacula/"]

RUN chmod +x /usr/local/bin/run

EXPOSE 9101

VOLUME ["/etc/bacula/", "/var/lib/bacula/", "/var/log/bacula/"]

ENTRYPOINT ["/usr/local/bin/run"]
