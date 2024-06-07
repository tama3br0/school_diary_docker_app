FROM ruby:3.2.3

RUN apt-get update -qq && apt-get install -y nodejs libmariadb-dev-compat libmariadb-dev

WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

RUN bundle install
RUN gem install aws-sdk-s3

COPY . /myapp

RUN ln -s /myapp/bin/rails /usr/local/bin/rails

# RAILS_ENVをproductionに設定
ENV RAILS_ENV production

# プロダクション環境用のアセットをプリコンパイル
RUN bundle exec rake assets:precompile
