source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

# rufus-scheduler for scheduled jobs
gem 'rufus-scheduler'

# Bunny as a rabbitmq client
gem 'bunny'

# Async
gem 'async'

# Faster JSON parsing
gem 'oj'

# Logging
gem 'console'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end
