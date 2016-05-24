require 'grape'

module API
  module V1
    module Entities
      class User < Grape::Entity
        expose :id
        expose :name
      end

      class Answer < Grape::Entity
        expose :id
        expose :question_id
        expose :body
        expose :user, as: :answerer, using: API::V1::Entities::User
      end

      class Question < Grape::Entity
        root 'questions'
        expose :id
        expose :title
        expose :user, as: :asker, using: API::V1::Entities::User
        expose :answers, using: API::V1::Entities::Answer
      end
    end
  end
end