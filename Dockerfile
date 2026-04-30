FROM ruby:4.0.3-slim

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends build-essential libsqlite3-dev libyaml-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .
RUN bundle install

EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
