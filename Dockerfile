FROM ruby:2.5.1

RUN apt-get update && apt-get install -y build-essential
RUN apt-get update && apt-get install -y mysql-client && rm -rf /var/lib/apt

RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
ENV BUNDLER_VERSION 2.0.2

RUN gem install bundler && bundle install --jobs 20 --retry 5
COPY . /app

