#
# Janus docker image

FROM debian:buster-slim

MAINTAINER Örjan Fors <orion@29k.org>

ENV DEBIAN_FRONTEND noninteractive

ENV JANUS_VERSION 0.2.5
ENV JANUS_SHA256 09610dc02ff0a1f23af0397baaa26a3cd88b3742d35b2e49849f099885cdcf08

RUN set -x \
	\
	&& groupadd -r janus && useradd -r -g janus janus \

	&& buildDeps=' \
		autoconf \
		automake \
		autopoint \
		autotools-dev \
		ca-certificates \
		curl \
		dpkg-dev \
		gengetopt \
		libavcodec-dev \
		libavformat-dev \
		libavutil-dev \
		libcurl4-openssl-dev \
		libglib2.0-dev \
		libjansson-dev \
		libmicrohttpd-dev \
		libnice-dev \
		libogg-dev \
		libopus-dev \
		librabbitmq-dev \
		libsofia-sip-ua-dev \
		libsrtp2-dev \
		libssl-dev \
		libtool \
		libwebsockets-dev \
		rename \
	' \
	&& apt-get update && apt-get install -y --no-install-recommends \
	  $buildDeps \
	  gosu \
	&& rm -r /var/lib/apt/lists/* \
	\
	&& curl -fSL -o janus.tar.gz "https://github.com/meetecho/janus-gateway/archive/v$JANUS_VERSION.tar.gz" \
	&& echo "$JANUS_SHA256 *janus.tar.gz" | sha256sum -c - \
	&& mkdir -p /usr/src/janus \
	&& tar -xzf janus.tar.gz -C /usr/src/janus --strip-components=1 \
	&& rm janus.tar.gz \
	\
	&& cd /usr/src/janus \
	\
	&& ./autogen.sh \
	&& ./configure \
		--prefix=/usr/local \
		--enable-post-processing \
	&& make \
	&& make install \
	\
	&& cd / \
	&& rm -r /usr/src/janus \
	&& rename 's/\.sample$//' /usr/local/etc/janus/*.sample \
	\
	&& apt-mark manual \
		libavcodec57 \
		libavformat57 \
		libavutil55 \
		libcurl3 \
		libglib2.0-0 \
		libjansson4 \
		libmicrohttpd12 \
		libnice10 \
		libogg0 \
		libopus0 \
		librabbitmq4 \
		libsofia-sip-ua0 \
		libsrtp2-1 \
		libssl1.1 \
		libwebsockets8 \
	&& apt-get purge -y --auto-remove $buildDeps \
	\
	&& janus -V

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 7088
EXPOSE 7188
EXPOSE 8088
EXPOSE 8188

CMD ["janus"]
