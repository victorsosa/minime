# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Link.create!(in_url: 'y', out_url: 'http://www.google.com')

class Spider
  REQUEST_INTERVAL = 1
  MAX_URLS = 1000

  attr_reader :handlers

  def initialize(processor, options = {})
    @processor = processor

    @results  = []
    @urls     = []
    @handlers = {}

    @interval = options.fetch(:interval, REQUEST_INTERVAL)
    @max_urls = options.fetch(:max_urls, MAX_URLS)

    enqueue(@processor.root, @processor.handler)
  end

  def enqueue(url, method, data = {})
    return if @handlers[url]

    @urls << url
    @handlers[url] ||= { method: method, data: data }
  end

  def record(data = {})
    @results << data
  end

  def results
    return enum_for(:results) unless block_given?

    i = @results.length
    enqueued_urls.each do |url, handler|
      begin
        # log 'Handling', url.inspect
        @processor.send(handler[:method], agent.get(url), handler[:data])
        if block_given? && @results.length > i
          yield @results.last
          i += 1
        end
      rescue StandardError => ex
        log 'Error', "#{url.inspect}, #{ex}"
      end
      sleep @interval if @interval > 0
    end
  end

    private

  def enqueued_urls
    Enumerator.new do |y|
      index = 0
      while index < @urls.count && index <= @max_urls
        url = @urls[index]
        index += 1
        next unless url

        y.yield url, @handlers[url]
      end
    end
  end

  def log(label, info)
    warn format('%-10s: %s', label, info)
  end

  def agent
    @agent ||= Mechanize.new
  end
  end

class WebCrawler
  attr_reader :root, :handler

  def initialize(root: 'https://wikipedia.org', handler: :process_index, **options)
    @root = root
    @handler = handler
    @options = options
  end

  def process_index(page, _data = {})
    page.links_with(href: %r{(http://|https://|ftp://).*}).each do |link|
      spider.enqueue(link.href, :process_index)
      fields = { url: link.href }
      # results[:link] = link.href
      spider.record _data.merge(fields)
    end
  end

  def results(&block)
    spider.results(&block)
  end

  private

  def spider
    @spider ||= Spider.new(self, @options)
  end
end

spider = WebCrawler.new

spider.results.lazy.take(5).each_with_index do |result, index|
  warn format('%-2s: %s', index, result.inspect)

  RestClient.post 'http://peopleware.do:3001/url.json', url: result[:url]
end
