FROM ruby:2.5.3

RUN apt-get update -qq && apt-get install -y  \
    build-essential                           \
    libpq-dev                                 \
    postgresql-client

# Force Bundler to work in parallel
RUN bundle config --global jobs 4
RUN echo 'gem: --no-document' > /root/.gemrc
RUN gem install foreman

## WebPack related installs:

# Install latest NodeJS as Javascript runtime for Rails
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get install -y nodejs

# Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y  yarn


RUN mkdir /webpack-thp

WORKDIR /webpack-thp
COPY Gemfile Gemfile
# COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /webpack-thp
WORKDIR /webpack-thp
