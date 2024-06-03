# Dockerfile
FROM ruby:3.2.3

RUN apt-get update -qq && apt-get install -y nodejs

WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

RUN bundle install

COPY . /myapp

RUN ln -s /myapp/bin/rails /usr/local/bin/rails
