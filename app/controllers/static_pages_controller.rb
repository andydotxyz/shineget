class StaticPagesController < ApplicationController

  def home
    if signed_in?
      redirect_to current_user
    end
  end

  def about
  end

  def admin
    redirect_to root_url, notice: "Permission denied" unless self.admin?self.current_user
  end
end

