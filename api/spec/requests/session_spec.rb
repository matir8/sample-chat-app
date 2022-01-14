# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Session endpoints', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:sign_in_url) { '/api/auth/sign_in' }
  let(:sign_out_url) { '/api/auth/sign_out' }
  let(:params) do
    {
      email: user.email,
      password: user.password
    }
  end

  describe 'POST /api/auth/sign_in' do
    context 'when login params are valid' do
      before { post(sign_in_url, params: params, as: :json) }

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns access-token in authentication header' do
        expect(response.headers['access-token']).to be_present
      end

      it 'returns client in authentication header' do
        expect(response.headers['client']).to be_present
      end

      it 'returns expiry in authentication header' do
        expect(response.headers['expiry']).to be_present
      end

      it 'returns uid in authentication header' do
        expect(response.headers['uid']).to be_present
      end
    end

    context 'when login params are invalid' do
      before { post(sign_in_url) }

      it 'returns unathorized status 401' do
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /api/auth/sign_out' do
    let(:headers) do
      {
        'uid' => response.headers['uid'],
        'client' => response.headers['client'],
        'access-token' => response.headers['access-token']
      }
    end

    before { post sign_in_url, params: params, as: :json }

    it 'returns status 200' do
      delete(sign_out_url, headers: headers)

      expect(response).to have_http_status(200)
    end
  end
end
