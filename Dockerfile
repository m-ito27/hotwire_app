FROM ruby:4.0.3-slim

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends build-essential libpq-dev libyaml-dev && \
    rm -rf /var/lib/apt/lists/*

ENV BUNDLE_PATH=/gems \
    BUNDLE_APP_CONFIG=/gems \
    PATH=/app/bin:$PATH

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .

EXPOSE 3000
CMD ["sh", "-c", "bin/rails db:prepare && bin/rails server -b 0.0.0.0"]
