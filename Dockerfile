FROM ruby:2.6.3 AS gourmet_share

RUN apt-get update -qq && apt-get install -y postgresql-client && gem install bundler

WORKDIR /gourmet_share

COPY Gemfile /gourmet_share/Gemfile
COPY Gemfile.lock /gourmet_share/Gemfile.lock

RUN bundle install

COPY . .
