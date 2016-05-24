module API
  module V1
    class Base < Grape::API
      mount API::V1::Questions
    end
  end
end