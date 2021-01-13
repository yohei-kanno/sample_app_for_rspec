FactoryBot.define do
  factory :task do
    sequence(:title){ |n| "やる事#{n}" }
    content { "本文" } 
    status  { "todo" }
    association :user
  end
end
