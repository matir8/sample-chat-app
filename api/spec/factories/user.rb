# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    nickname { Faker::Internet.user_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
