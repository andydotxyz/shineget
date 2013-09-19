require 'open-uri'

class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /list/:list_id/items/new
  def new
    @list = List.find(params[:list_id])
    @item = Item.new
    @item.list = @list

    if params[:url].present?
      @item.url = params[:url]
    end

    if params[:title].present?
      @item.title = params[:title]
    end

    if params[:notes].present?
      @item.notes = params[:notes]
    end

    if params[:imgurl].present?
      @item.imgurl = params[:imgurl]
    end

    if params[:price].present?
      @item.price = params[:price]
    end
  end

  # GET /list/:list_id/items/findfromurl?url=something
  def find_from_url
    @list = List.find(params[:list_id])

    @item = ItemParser.parse(params['url'])
    @item.id = -1

    @add_url = '/lists/' + @list.id.to_s + '/items/addfromurl?url=' + CGI::escape(params['url'])
    @edit_url = new_list_item_path + '?list_id=' + @list.id.to_s + '&url=' + @item.url + '&title=' + @item.title.to_s +
    '&imgurl=' + @item.imgurl.to_s + '&price=' + @item.price.to_s + '&notes=' + @item.notes.to_s
  end

  # POST /list/:list_id/items/addfromurl?url=something
  def add_from_url
    @list = List.find(params[:list_id])

    @item = ItemParser.parse(params['url'])
    @item.list = @list
    @item.save

    redirect_to current_user
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render action: 'show', status: :created, location: @item }
      else
        format.html { render action: 'new' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to list_items_url @item.list }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:url, :title, :notes, :imgurl, :price, :list_id)
    end
end
