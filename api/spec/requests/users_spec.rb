# frozen_string_literal: true

require 'rails_helper'
require 'json'

RSpec.describe 'Users', type: :request do
  describe 'GET /api/users' do
    let(:user1) { FactoryBot.create(:user) }
    let(:user2) { FactoryBot.create(:user) }
    let(:users_url) { '/api/users' }
    let(:result) { JSON.parse(response.body)['data'] }
    let(:auth_headers) { user1.create_new_auth_token }

    before do
      user2

      get(users_url, params: {}, headers: auth_headers)
    end

    it 'returns status 200' do
      expect(response).to have_http_status(200)
    end

    it 'lists all users correctly' do
      expect(result).to all have_type(:user)
      expect(result).to all have_jsonapi_attributes(:name, :nickname).exactly

      expect(result).to include have_attribute(:name).with_value(user1.name)
      expect(result).to include have_attribute(:nickname).with_value(user1.nickname)

      expect(result).to include have_attribute(:name).with_value(user2.name)
      expect(result).to include have_attribute(:nickname).with_value(user2.nickname)
    end

    context 'with search query' do
      before do
        user2

        get(users_url, params: { search: user1.name.slice(-3, 3) }, headers: auth_headers)
      end

      it 'searches the users correctly' do
        expect(result.size).to eq 1

        expect(result.first).to have_id user1.id.to_s
      end
    end
  end
end
