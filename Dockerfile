FROM kadock/s6:edge

RUN apk --no-cache add lighttpd

RUN true \
  && mkfifo -m 600 /var/run/stderr \
  && chown lighttpd:lighttpd /var/run/stderr \
  && mkfifo -m 600 /var/run/stdout \
  && chown lighttpd:lighttpd /var/run/stdout \
  && sed -i 's#^var.logdir.*#var.logdir   = "/var/run"#' /etc/lighttpd/lighttpd.conf \
  && sed -i 's#^server.errorlog.*#server.errorlog      = var.logdir  + "/stderr"#' /etc/lighttpd/lighttpd.conf \
  && sed -i 's#^accesslog.filename.*#accesslog.filename   = var.logdir + "/stdout"#' /etc/lighttpd/lighttpd.conf

RUN true \
  && wget -O /tmp/lighttpd.tar.xz https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.65.tar.xz \
  && mkdir /tmp/lighttpd \
  && tar -C /tmp/lighttpd -Jxpf /tmp/lighttpd.tar.xz --strip-components 1 \
  && cp /tmp/lighttpd/doc/config/conf.d/mime.conf /etc/lighttpd/mime-types.conf \
  && rm -rf /tmp/lighttpd /tmp/lighttpd.tar.xz

COPY etc /etc/

RUN chmod +x /etc/services.d/stdout/run
RUN chmod +x /etc/services.d/stderr/run

VOLUME /var/www/localhost/htdocs

EXPOSE 80/tcp

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
