FROM ruby:3.2.2 AS base

RUN apt-get update && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
    nodejs=\* \
    npm=\* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g yarn

RUN gem install rails:7.0.7.2

WORKDIR /workspace

FROM base AS development

COPY Gemfile* .
RUN bundle install

COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
