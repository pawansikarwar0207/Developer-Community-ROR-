FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    user
    hidden { false }

    # Associations
    association :user
    association :page
    association :group
  end
end
