image = kadock/s6-lighttpd:edge
log = --log-driver journald --log-opt mode=non-blocking
name = --name lighttpd

build:
	docker build -t ${image} .

run:
	docker run --rm -i -t ${volumes} ${image}

shell:
	docker run --rm -i -t ${name} ${volumes} ${image} /bin/sh

ping:
	docker run --rm ${name} ${log} ${volumes} ${image} /bin/sh -c "ping 8.8.8.8 >> /var/run/stdout"
