require 'open-uri'

class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :buy, :bought, :cancelled, :destroy]

  # GET /items/1
  # GET /items/1.json
  def show
    redirect_to @item.url
  end

  # GET /items/1/buy
  def buy
    @item.bought = false
    @item.save
  end

  def bought
    @item.bought = true
    @item.save
    redirect_to @item.list.user
  end

  def cancelled
    @item.bought = false
    @item.save
    redirect_to @item.list.user
  end

  # GET /lists/:list_id/items/findfromurl?url=something
  def find_from_url
    if params['url'].empty?
      flash.keep[:error] = 'Item URL is required'
      redirect_to '/'
      return
    end

    @list = List.find(params[:list_id])

    begin
      @item = ItemParser.parse(params['url'])
    rescue StandardError => e
      flash.keep[:error] = 'Unable to import list - ' + e.message
      redirect_to '/'
    end

    @add_url = '/lists/' + @list.id.to_s + '/items/addfromurl?url=' + CGI::escape(params['url'])
  end

  # POST /lists/:list_id/items/addfromurl?url=something
  def add_from_url
    @list = List.find(params[:list_id])

    @item = ItemParser.parse(params['url'])
    @item.list = @list
    @item.save

    redirect_to current_user
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to current_user }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:item_id]?params[:item_id]:params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:url, :title, :notes, :imgurl, :price, :list_id)
    end
end
