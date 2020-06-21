
FactoryBot.define do
  factory :user do
    name { 'テストユーザー'}
    email { 'test1@example.com' }
    password { 'password' }
  end

  factory :admin_user, parent: :user do
    admin { true }
  end
end
