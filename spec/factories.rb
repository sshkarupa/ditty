# frozen_string_literal: true

require 'faker'
require 'ditty/models/user'
require 'ditty/models/identity'
require 'ditty/models/role'

FactoryBot.define do
  to_create(&:save)

  sequence(:email) { |n| "person-#{n}@example.com" }
  sequence(:name) { |n| "Name-#{n}" }

  factory :user, class: Ditty::User, aliases: [:'Ditty::User'] do
    email

    after(:create) do |user, _evaluator|
      create(:identity, user: user)
    end

    factory :super_admin_user do
      after(:create) do |user, _evaluator|
        user.add_role(Ditty::Role.find_or_create(name: 'super_admin'))
      end
    end
  end

  factory :identity, class: Ditty::Identity, aliases: [:'Ditty::Identity'] do
    username { generate :email }
    crypted_password { 'som3Password!' }
  end

  factory :role, class: Ditty::Role, aliases: [:'Ditty::Role'] do
    name { "Role #{generate(:name)}" }
  end

  factory :user_login_trait, class: Ditty::UserLoginTrait, aliases: [:'Ditty::UserLoginTrait'] do
    user
    ip_address { Faker::Internet.ip_v4_address }
    platform { Faker::Device.platform }
    device { Faker::Device.model_name }
    browser { 'Firefox' }
  end
end
