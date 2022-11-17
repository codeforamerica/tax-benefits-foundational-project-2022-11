FROM ruby:3.1.2

# System prerequisites
RUN apt-get update \
 && apt-get -y install build-essential libpq-dev \
 && rm -rf /var/lib/apt/lists/*

# If you require additional OS dependencies, install them here:
# RUN apt-get update \
#  && apt-get -y install imagemagick nodejs \
#  && rm -rf /var/lib/apt/lists/*

ADD Gemfile /app/
ADD Gemfile.lock /app/
WORKDIR /app
RUN BUNDLE_FROZEN=true bundle install

ADD . /app
RUN RAILS_ENV=production bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000"]