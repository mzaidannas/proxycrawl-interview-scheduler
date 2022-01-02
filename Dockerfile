# Using alpine image for small size
FROM ruby:3.1.0-alpine

# Install runtime dependencies
RUN apk update && apk add --update tzdata shared-mime-info git

# Use virtual build-dependencies tag so we can remove these packages after bundle install
RUN apk add --update --no-cache --virtual build-dependency libxml2-dev libxslt-dev build-base ruby-dev libcurl

# Set an environment variable where the SCHEDULER app is installed to inside of Docker image
ENV SCHEDULER_ROOT /var/www/proxycrawler/api

# make a new directory where our project will be copied
RUN mkdir -p $SCHEDULER_ROOT

# Set working directory within container
WORKDIR $SCHEDULER_ROOT

ARG SCHEDULER_ENV
ENV SCHEDULER_ENV $SCHEDULER_ENV

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler -v 2.2.33

# development/production differs in bundle install
RUN if [[ "$SCHEDULER_ENV" == "test" ]]; then\
 bundle check || bundle install --jobs 8 --retry 5 --without development;\
 elif [[ "$SCHEDULER_ENV" != "development" ]]; then\
 bundle check || bundle install --jobs 8 --retry 5 --without development test;\
 else bundle check || bundle install; fi

# Remove build dependencies and install runtime dependencies
RUN if [[ "$SCHEDULER_ENV" != "development" ]]; then\
  apk del build-dependency &&\
  apk add --update libxml2 libxslt libcurl; fi

# Adding project files
COPY . .

# Use ruby's jit in time compiler for better performance
ENV RUBY_OPT "--yjit"

ENTRYPOINT [ "./entrypoint.sh" ]

CMD [ "ruby", "scheduler.rb" ]
