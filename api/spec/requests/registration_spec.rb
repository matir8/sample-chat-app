# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registration', type: :request do
  let(:sign_up_url) { '/api/auth' }
  let(:email) { 'employee@gainimpact.nl' }
  let(:password) { 'Str0ngP@$$w0rd' }
  let(:password_confirmation) { 'Str0ngP@$$w0rd' }
  let(:name) { 'John Doe' }
  let(:nickname) { 'j.doe' }
  let(:image) { 'https://picsum.photos/id/237/200/300' }
  let(:params) do
    {
      email: email,
      password: password,
      password_confirmation: password_confirmation,
      name: name,
      nickname: nickname,
      image: image
    }
  end
  let(:data) { JSON.parse(response.body)['data'] }

  describe 'Email registration method' do
    describe 'POST /api/auth/' do
      context 'when signup params is valid' do
        before { post(sign_up_url, params: params) }

        it 'returns status 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns authentication header with right attributes' do
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

        it 'returns status success' do
          parsed_response = JSON.parse(response.body)

          expect(parsed_response['status']).to eq('success')
        end

        it 'returns the email' do
          expect(data['email']).to eq 'employee@gainimpact.nl'
        end

        it 'returns the name' do
          expect(data['name']).to eq 'John Doe'
        end

        it 'returns the nickname' do
          expect(data['nickname']).to eq 'j.doe'
        end

        it 'returns the image' do
          expect(data['image']).to eq 'https://picsum.photos/id/237/200/300'
        end

        it 'creates new user' do
          expect do
            post(sign_up_url, params: params.merge(email: 'test@gainimpact.nl'))
          end.to change(User, :count).by(1)
        end
      end

      context 'when signup params is invalid' do
        before { post(sign_up_url) }

        it 'returns unprocessable entity 422' do
          expect(response.status).to eq 422
        end
      end
    end
  end
end
