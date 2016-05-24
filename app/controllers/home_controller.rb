class HomeController < ApplicationController
  layout '_base'

  def stats
    @total_users = User.count
    @total_questions = Question.count
    @total_answers = Answer.count
    @total_requests = Tenant.total_requests

    @tenants = Tenant.dashboard_table_data
  end

end
