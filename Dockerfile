FROM docker:stable

LABEL author="Tim Rowe <tim@tjsr.id.au>"

RUN apk --no-cache add openssh-client

COPY /docker-pull-entrypoint.sh /docker-pull-entrypoint.sh
RUN chmod +x /docker-pull-entrypoint.sh

ENTRYPOINT ["/docker-pull-entrypoint.sh"]