FactoryBot.define do
  factory :message do
    content { "MyText" }
    sent_at { "2022-11-30 15:59:40" }
    user { nil }
    chat { nil }
  end
end
