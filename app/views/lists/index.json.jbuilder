json.array!(@lists) do |list|
  json.extract! list, :url, :name, :updated, :user_id
  json.url list_url(list, format: :json)
end
