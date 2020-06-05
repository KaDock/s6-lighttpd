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

COPY etc /etc/

VOLUME /var/www/localhost/htdocs

EXPOSE 80/tcp

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
