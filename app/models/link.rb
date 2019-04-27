# frozen_string_literal: true

class Link < ApplicationRecord
  validates :in_url, :out_url, :http_status, presence: true
  validates :in_url, uniqueness: true
end
