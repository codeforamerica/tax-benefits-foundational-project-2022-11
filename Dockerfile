FROM ruby:3.1.2

# System prerequisites
RUN apt-get update \
 && apt-get -y install build-essential libgnutls30 libpq-dev nodejs \
 && rm -rf /var/lib/apt/lists/*

# If you require additional OS dependencies, install them here:
# RUN apt-get update \
#  && apt-get -y install imagemagick nodejs \
#  && rm -rf /var/lib/apt/lists/*

ADD Gemfile* /app/
WORKDIR /app
RUN BUNDLE_FROZEN=true bundle install

ADD . /app
RUN set -a && \
    . /app/.aptible.env && \
    cat /app/.aptible.env && \
    RAILS_ENV=production bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000"]

RUN apt-get -yqq install curl

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost:${PORT}/ || exit 1