class Tenant < ActiveRecord::Base

  before_create :generate_api_key

  def self.total_requests
    sum(:request_count)
  end

  def self.dashboard_table_data
    pluck(:name, :request_count)
  end

  private

  def generate_api_key
    self.api_key = SecureRandom.hex(16)
  end

end
