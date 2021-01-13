FactoryBot.define do
  factory :task do
    sequence(:title){ |n| "やる事#{n}" }
    sequence(:content){ |n| "本文#{n}" }
    status{ "todo" }
    association :user
  end
end
