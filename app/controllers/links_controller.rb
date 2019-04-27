# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :set_link, only: %i[show edit update destroy]

  def go
    if params[:url].blank?
      @link = Link.find_by_in_url!(params[:in_url])
      redirect_to @link.out_url, status: @link.http_status
    elsif !params[:url].blank?
      render json: generateShortUrl(params[:url]), status: :ok
    end
  end

  def top
    @links = Link.all
    render json: @links, status: :ok
  end

  def generateShortUrl(url)
    
  end

  # GET /links
  # GET /links.json
  def index
    @links = Link.order(counter: :desc).limit(100)
  end

  # GET /links/1
  # GET /links/1.json
  def show; end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit; end

  # POST /links
  # POST /links.json
  def create
    @link = Link.new(link_params)

    respond_to do |format|
      if @link.save
        format.html { redirect_to @link, notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_link
    @link = Link.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def link_params
    params.require(:link).permit(:in_url, :out_url, :http_status, :counter, :title)
  end
end
