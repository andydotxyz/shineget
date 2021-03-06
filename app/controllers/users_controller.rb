class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:index]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  # GET /users/1.xml
  def show
    (@user = User.find_by_username(params[:id])) or not_found and return

    respond_to do |format|
      format.html
      format.json { render json: @user.to_json( :except => [:id, :password_digest, :remember_token],
                                                :include => { :lists => { :except => [:id, :user_id],
                                                                          :include => { :items => { :except => [:id, :list_id] } } } } ) }
      format.xml { render json: @user.to_xml( :except => [:id, :password_digest, :remember_token],
                                              :include => { :lists => { :except => [:id, :user_id],
                                                                        :include => { :items => { :except => [:id, :list_id] } } } } ) }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to Shine Get!"

        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by_username(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :fullname, :email, :password,
                                   :password_confirmation)
    end

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end

    def correct_user
      @user = User.find_by_username(params[:id])
      redirect_to root_url, notice: "Permission denied" unless self.current_user?(@user)
    end

    def admin_user
      redirect_to root_url, notice: "Permission denied" unless self.admin?self.current_user
    end
end
