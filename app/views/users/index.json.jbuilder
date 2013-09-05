json.array!(@users) do |user|
  json.extract! user, :username, :fullname, :email
  json.url user_url(user, format: :json)
end
