module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do

        # common Grape settings
        version 'v1'
        format :json

        THROTTLE_RULES = [
            { 'req_count' => 100, 'duration' => 24.hours },
            { 'req_count' => 1, 'duration' => 10.seconds }
        ]

        before do
          error!('401 Unauthorized', 401) unless authenticated

          # Bonus 2: Add a piece of middleware to throttle API requests on a per-Tenant basis.
          # After the first 100 requests per day, throttle to 1 request per 10 seconds.
          validate_throttle

          update_tenant_request_count
        end

        rescue_from Grape::Exceptions::ValidationErrors do |e|
          error!({ error: 'Bad Request', errors: e.full_messages }, 400)
        end

        helpers do
          def authenticated
            valid_token?(params[:token]) && Tenant.find_by(:api_key => params[:token])
          end

          def valid_token?(token)
            token && token.length.eql?(32)
          end

          def update_tenant_request_count
            tenant = Tenant.find_by(:api_key => params[:token])
            tenant.increment!(:request_count) if tenant
          end

          def validate_throttle
            error!('429 Too many requests', 429) if ApiThrottle.threshold?(params['token'], THROTTLE_RULES)
          end
        end

      end
    end
  end
end