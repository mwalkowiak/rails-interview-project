require 'rails_helper'

describe 'API::V1::Throttle', type: :request do

  let(:api_endpoint) { '/api/v1/questions' }
  let(:tenant) { FactoryGirl.create :tenant }

  let(:first_limit_req_count) { 100 }
  let(:second_limit_req_count) { 1 }

  before do
    2.times { FactoryGirl.create :question, :with_answers, :number_of_answers => 5 }
  end

  context 'number of requests is lower than the limit' do
    it 'does not change the request status meeting the first rule' do
      first_limit_req_count.times do
        get api_endpoint, token: tenant.api_key
        expect(response.status).to_not eq(429)
      end
    end

    it 'does not change the request status meeting the second rule' do
      (first_limit_req_count + second_limit_req_count).times do
        get api_endpoint, token: tenant.api_key
        expect(response.status).to_not eq(429)
      end
    end
  end

  context 'number of requests for a shorter second limit' do
    it 'does not change the request status' do
      first_limit_req_count.times do
        get api_endpoint, token: tenant.api_key
        expect(response.status).to eq(200)
      end

      get api_endpoint, token: tenant.api_key
      expect(response.status).to eq(200)

      sleep 10.seconds
      expect(response.status).to eq(200)
    end

    it 'does change the request status' do
      first_limit_req_count.times do
        get api_endpoint, token: tenant.api_key
        expect(response.status).to eq(200)
      end

      get api_endpoint, token: tenant.api_key
      expect(response.status).to eq(200)

      sleep 5.seconds
      get api_endpoint, token: tenant.api_key
      expect(response.status).to eq(429)
      expect(JSON.parse(response.body)['error']).to eq('429 Too many requests')
    end
  end



end