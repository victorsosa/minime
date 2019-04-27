# frozen_string_literal: true

class ScrapJob < ApplicationJob
  queue_as :default

  def perform(link)
    # link = Link.find(link_id)
    agent = Mechanize.new
    # TODO: need to implement SSL
    agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    page = agent.get(link.out_url)
    link.title = page.title
    link.save
  end
end
