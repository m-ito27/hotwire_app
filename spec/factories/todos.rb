FactoryBot.define do
  factory :todo do
    sequence(:title) { |n| "やること #{n}" }
    completed { false }
    user
  end
end
