# frozen_string_literal: true

class Link < ApplicationRecord
  validates :out_url, :http_status, presence: true
  validates :in_url, uniqueness: true
  validates :out_url, url: { schemes: ['https', 'http'] }

  after_create :scrap, :generate_short_url

  def scrap
    ScrapJob.perform_later self
  end

  def generate_short_url
    self.in_url = id.to_s(36)
    logger.debug 'link: ' + inspect
    save!
  end
end
