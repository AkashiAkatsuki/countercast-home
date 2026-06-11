ARG JEKYLL_IMAGE=jekyll/jekyll:4.2.2
FROM ${JEKYLL_IMAGE}

USER root

RUN gem install \
    jekyll-remote-theme:0.4.3 \
    jekyll-seo-tag:2.8.0 \
    webrick:1.8.1 \
    --no-document

WORKDIR /srv/jekyll

CMD ["jekyll", "serve", "--host", "0.0.0.0", "--port", "4000", "--watch", "--force_polling"]
