FROM ruby:2.5.3-slim
ARG precompileassets

RUN mkdir -p /usr/share/man/man1
RUN mkdir -p /usr/share/man/man7

RUN apt-get -y update && \
    apt-get install --fix-missing --no-install-recommends -qq -y \
    build-essential \
    emacs \
    wget gnupg \
    git-all \
    curl \
    ssh \
    postgresql-client libpq5 libpq-dev -y && \
    wget -qO- https://deb.nodesource.com/setup_9.x  | bash - && \
    apt-get install -y nodejs && \
    wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV RAILS_ENV development
#ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
#ENV RAILS_LOG_TO_STDOUT true

RUN gem install bundler

ARG INSTALL_PATH=/opt/dockerrails
ENV INSTALL_PATH $INSTALL_PATH
WORKDIR $INSTALL_PATH
COPY . .

RUN bundle install
RUN scripts/potential_asset_precompile.sh $precompileassets
CMD ["bundle exec bin/delayed_job restart"]
CMD ["./scripts/start_rails.sh"]
