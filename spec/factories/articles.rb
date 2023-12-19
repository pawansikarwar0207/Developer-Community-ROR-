FactoryBot.define do
  factory :article do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    association :user
    created_at { Time.current }
    updated_at { Time.current }
  end
end
