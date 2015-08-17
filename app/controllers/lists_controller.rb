class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]

  # GET /lists/1
  # GET /lists/1.json
  def show
    @items = @list.items.paginate(page: params[:page])
  end

  # GET /lists/new
  def new
    return if params['website'].nil?

    if params['identifier'].empty?
      flash.now[:error] = 'List ID is required'
      return
    end

    new_url = nil
    if params['website'] == 'amazon.co.uk' && params['identifier']
      new_url = 'http://www.amazon.co.uk/registry/wishlist/' + params['identifier'] + '?items-per-page=10000'
    end

    redirect_to '/lists/findfromurl?url=' + CGI::escape(new_url) + '&source=' + params['website'] if new_url
  end

  # GET /lists/findfromurl?url=something
  def find_from_url
    begin
      @list = ListParser.parse_sample(params['url'], params['source'])
    rescue StandardError => e
      flash.now[:error] = 'Unable to import list - ' + e.message
      render :new
    end

    @add_url = '/lists/addfromurl?url=' + CGI::escape(params['url']) + '&source=' + params['source']
  end

  # POST /lists/addfromurl?url=something
  def add_from_url
    fork do
      @list = ListParser.parse(params['url'], params['source'])
      @list.user = current_user

      items_cache = []
      @list.items.each { |item| items_cache << item }
      @list.items.clear
      @list.save!

      items_cache.each { |item|
        item.list = @list
        @list.items << item

        item.save!
      }
      @list.save!
      exit
    end

    flash.keep[:info] = 'Your wish list is being added and will appear shortly'
    redirect_to current_user
  end

  # GET /lists/1/edit
  def edit
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = List.new(list_params)

    respond_to do |format|
      if @list.save
        format.html { redirect_to @list, notice: 'List was successfully created.' }
        format.json { render action: 'show', status: :created, location: @list }
      else
        format.html { render action: 'new' }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list, notice: 'List was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @list.destroy
    respond_to do |format|
      format.html { redirect_to current_user }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:url, :name, :updated, :user_id)
    end

    def correct_user
      redirect_to root_url, notice: "Permission denied" unless self.current_user?(@list.user)
    end
end
