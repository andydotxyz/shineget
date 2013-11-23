class StaticPagesController < ApplicationController

  def home
    # deal with custom domains
    if is_user_request?
      redirect_to 'http://shineget.me/users/' + username_from_host
      return
    end

    if signed_in?
      redirect_to current_user
    end
  end

  def about
  end

  def admin
    redirect_to root_url, notice: "Permission denied" unless self.admin?self.current_user
  end

  #custom domain stuff
  def is_user_request?
    if request.host.length < 13
      false
    end

    !User.find_by_username(username_from_host).nil?
  end

  def username_from_host
    request.host.sub('.shineget.me', '')
  end
end

