json.array!(@items) do |item|
  json.extract! item, :url, :notes, :price, :list_id
  json.url item_url(item, format: :json)
end
