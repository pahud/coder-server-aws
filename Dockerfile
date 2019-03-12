FROM abiosoft/caddy as caddy
FROM codercom/code-server as codesrv

# Let's Encrypt Agreement
ENV ACME_AGREE="true"

VOLUME /root/.caddy /srv
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=caddy /etc/Caddyfile /etc/Caddyfile
COPY --from=caddy /srv/index.html /srv/index.html
COPY --from=caddy /bin/parent /bin/parent

#RUN apt-cache search certifi; exit 1
RUN apt-get install -y supervisor ca-cacert curl


ADD caddy.conf /etc/supervisor/conf.d/caddy.conf
ADD coder.conf /etc/supervisor/conf.d/coder.conf
ADD Caddyfile /tmp/Caddyfile.tmp
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

