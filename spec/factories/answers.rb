FactoryGirl.define do
  factory :answer do
    body FFaker::Lorem.phrase
    question
    user
  end

  trait :with_answers do
    transient do
      number_of_answers 3
    end

    after :create do |question, expositor|
      FactoryGirl.create_list :answer, expositor.number_of_answers, :question => question
    end
  end
end