module UsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user)
    image_tag(gravatar_url_for(user), alt: user.username, class: 'gravatar')
  end

  def gravatar_url_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)

    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=120"
  end
end
