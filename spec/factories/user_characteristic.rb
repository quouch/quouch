FactoryBot.define do
  factory :user_characteristic do
    characteristic { Characteristic.all.sample }
  end
end
