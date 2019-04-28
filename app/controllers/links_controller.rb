# frozen_string_literal: true

class LinksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def go
    @link = Link.find_by!(in_url: params[:in_url])
    @link.counter += 1 # increse counter
    @link.save
    redirect_to @link.out_url, status: @link.http_status
  rescue ActiveRecord::RecordNotFound
    render json: @link.errors, status: :unprocessable_entity
  end

  def top
    @links = Link.order(counter: :desc).limit(100)
    render json: @links, status: :ok
  end

  def generate_short_url
    # generate shorter url
    @link = Link.new(out_url: params[:url], counter: 1)
    if @link.save
      render json: short_url(params[:url]), status: :ok
    else
      render json: @link.errors, status: :unprocessable_entity
    end
  end
end
