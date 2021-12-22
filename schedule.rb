require 'bundler'

Bundler.require(:default, :development)

require_relative 'publisher'

begin
  scheduler = Rufus::Scheduler.new

  scheduler.at '10:00:00' do
    Console.logger.info 'Job at 10:00:00 Started'
    Publisher.push_data({ consumer: 'Crawler', processor: 'TopSearches', data: { urls: ['https://ahrefs.com/blog/top-amazon-searches'] } },
                        'urls')
  end

  scheduler.every '1s' do
    Console.logger.info 'Job every 1s Started'
    Publisher.push_data({ consumer: 'Crawler', processor: 'TopSearches', data: { urls: ['https://ahrefs.com/blog/top-amazon-searches'] } },
                        'urls')
  end

  scheduler.join

  Publisher.close
rescue SystemExit, Interrupt => e
  Console.logger.info "Received Signal #{e.class}"
  Console.logger.info 'Closing connection to RabbitMQ'
  Publisher.close
  Console.logger.info 'Shutting Down scheduler'
  scheduler.shutdown
  exit
end
