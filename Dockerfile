FROM alpine:3.12 as builder

RUN apk --no-cache add build-base imagemagick

# it's actually just a tar, not gzipped
ADD https://www.w3.org/Daemon/httpd/w3c-httpd-3.0A.tar.gz /tmp/httpd/httpd.tar

COPY httpd-patches.patch /tmp/httpd/

WORKDIR /tmp/httpd
RUN tar -x -f httpd.tar && \
  patch -p0 -i httpd-patches.patch && \
  ./BUILD.SH && \
  mkdir bin && \
  cp Daemon/linux/cgiparse bin/ && \
  cp Daemon/linux/cgiutils bin/ && \
  cp Daemon/linux/htadm bin/ && \
  cp Daemon/linux/htimage bin/ && \
  cp Daemon/linux/httpd_3.0A bin/httpd && \
  # convert XBM icons to GIF
  mogrify -format gif /tmp/httpd/server_root/icons/*.xbm

FROM alpine:3.12
COPY --from=builder /tmp/httpd/server_root /srv/server_root
COPY --from=builder /tmp/httpd/bin /usr/local/bin

COPY httpd.conf /etc/httpd.conf

RUN mkdir /srv/www && \
  addgroup httpd && adduser -HD httpd -G httpd

USER httpd

ENTRYPOINT ["httpd"]