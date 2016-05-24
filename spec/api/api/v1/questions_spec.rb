require 'rails_helper'

describe 'API::V1::Questions', type: :request do

  let(:api_endpoint) { '/api/v1/questions' }
  let(:tenant) { FactoryGirl.create :tenant }
  let(:user) { FactoryGirl.create :user }

  before do
    10.times { FactoryGirl.create :question, :with_answers, :number_of_answers => 5 }
  end

  context 'API key access' do
    it 'should return 401 when invalid token is given' do
      get api_endpoint, token: 'InvalidToken'
      expect(response.status).to eq(401)
    end

    it 'should return 200 when valid token is given' do
      get api_endpoint, token: tenant.api_key
      expect(response.status).to eq(200)
      expect(response.body).to_not be_empty
    end
  end

  context 'Questions data' do
    it 'should return 10 questions' do
      get api_endpoint, token: tenant.api_key
      expect(response.status).to eq(200)
      expect(response.body).to_not be_empty
      expect(JSON.parse(response.body)['questions'].length).to eq(10)
    end

    it 'should have 5 answers for every question' do
      get api_endpoint, token: tenant.api_key
      expect(response.status).to eq(200)
      expect(response.body).to_not be_empty
      expect(JSON.parse(response.body)['questions'].first['answers'].length).to eq(5)
    end
  end

  context 'Query support' do
    before do
      @additional_query_question = FactoryGirl.create :question, title: 'Additional query question'
      @answer = FactoryGirl.create :answer, :question => @additional_query_question, :user => user
    end

    it 'should support additional query' do
      get api_endpoint, token: tenant.api_key, query: 'query question'
      expect(response.status).to eq(200)
      expect(response.body).to_not be_empty
      expect(JSON.parse(response.body)['questions'].length).to eq(1)
    end

    it 'should return 1 answer for given question' do
      get api_endpoint, token: tenant.api_key, query: 'query question'
      expect(response.status).to eq(200)
      expect(response.body).to_not be_empty
      expect(JSON.parse(response.body)['questions'].first['answers'].first['body']).to eq(@answer.body)
    end

    it 'should return 404 when no results found' do
      get api_endpoint, token: tenant.api_key, query: 'non existing query'
      expect(response.status).to eq(404)
      expect(JSON.parse(response.body)['error']).to eq('No questions found')
    end
  end

end