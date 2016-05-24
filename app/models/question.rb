class Question < ActiveRecord::Base
  has_many :answers
  belongs_to :user

  scope :private_with_users_and_answers, -> { includes(:user).includes(answers: :user).where(private: false) }
  scope :only_with_query, -> (query) { where('title LIKE ?', "%#{query}%") }
end
