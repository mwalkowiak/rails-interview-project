module API
  module V1
    class Questions < Grape::API
      include API::V1::Defaults

      resource :questions do

        desc 'Return a list of questions', { :entity => API::V1::Entities::Question }

        params do
          optional :query, type: String, desc: 'Select only Questions that contain the query term(s)'
        end

        get '/' , http_codes: [
          [200, 'Ok', API::V1::Entities::Question]
        ] do
          questions = Question.private_with_users_and_answers

          # Bonus 1: Allow adding a query parameter to the API request to select only Questions that contain the query term(s)
          questions = questions.only_with_query(params[:query]) if params[:query] && !params[:query].empty?
          error!('No questions found', 404) if questions.empty?

          present questions, with: API::V1::Entities::Question
        end
      end
    end
  end
end