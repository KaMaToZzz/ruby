ARG RUBY_VERSION=3.0-rc
FROM ruby:${RUBY_VERSION}
ENV NODE_VERSION=14
WORKDIR /app
COPY . /app/
# should solve DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sL "https://deb.nodesource.com/setup_${NODE_VERSION}.x" | bash - && \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get -y install \
    libpq-dev nodejs \
    yarn --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*
RUN yarn && yarn build
RUN bundle install
RUN rails assets:precompile