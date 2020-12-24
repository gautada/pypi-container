FROM alpine:3.12.1 as config-alpine

RUN apk add --no-cache tzdata

RUN cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN echo "America/New_York" > /etc/timezone

FROM alpine:3.12.1

EXPOSE 8080/tcp

RUN apk add --no-cache  python3 \
                        py3-pip

COPY --from=config-alpine /etc/localtime /etc/localtime
COPY --from=config-alpine /etc/timezone /etc/timezone

RUN pip3 install --no-cache-dir pip pypiserver

RUN mkdir -p /opt/pypi-data

VOLUME ["/opt/pypi-data"]

ENTRYPOINT["/usr/bin/pypi-server"]
# ENTRYPOINT["/usr/bin/pypi-server", "-vv", "-P", ".", "-a", ".", "-p", "8080", "/opt/pypi/packages"]
