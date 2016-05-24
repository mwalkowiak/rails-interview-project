FactoryGirl.define do
  # For the sake of testing query support we stick with pattern here
  sequence(:title) { |n| "Sample question number #{n}" }

  factory :question do
    title
    private false
    user
  end
end