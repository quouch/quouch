json.pagination do
  json.current_page @pagy.vars[:page]
  json.per_page @pagy.vars[:items]
  json.total_entries @pagy.vars[:count]
end

json.couches @couches do |couch|
  json.id couch.id

  json.user do
    json.id couch.user.id
    json.name couch.user.first_name

    json.photo do
      json.filename couch.user.photo.filename
      json.url url_for(couch.user.photo)
    end
  end
end
