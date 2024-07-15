json.user do
  json.id @user.id
  json.first_name @user.first_name
  json.last_name @user.last_name
  json.email @user.email
  json.birthdate @user.date_of_birth
  json.pronouns @user.pronouns
  json.invite_code @user.invite_code

  json.address do
    json.street @user.address
    json.zip @user.zipcode
    json.country @user.country
    json.city @user.city
    json.latitude @user.latitude
    json.longitude @user.longitude
  end

  json.photo do
    json.filename @user.photo.filename
    json.url url_for(@user.photo)
  end

  json.characteristics do
    json.array! @user.characteristics, :id, :name
  end

  json.status do
    json.travelling @user.travelling
    json.offers_couch @user.offers_couch
    json.offers_co_work @user.offers_co_work
    json.offers_hang_out @user.offers_hang_out
  end

  json.summary @user.summary
  json.passion @user.passion

  json.questions do
    json.child! do
      json.question "This makes me really happy"
      json.answer @user.question_one
    end
    json.child! do
      json.question "What I can't stand"
      json.answer @user.question_two
    end
    json.child! do
      json.question "What I need from the people around me"
      json.answer @user.question_three
    end
  end

  # if @user.couch?
  #   json.couch do
  #     json.capacity @user.couch.capacity
  #     json.facilities do
  #       json.array! @user.couch.facilities, :id, :name
  #     end
  #   end
  # end
end
