require 'rails_helper'

describe 'セッション管理機能', type: :system do
  let(:user) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }

  before do
    visit login_path
    fill_in 'メールアドレス', with: email
    fill_in 'パスワード', with: password
    click_button 'ログインする'
  end

  describe 'ログイン機能' do
    context 'ログイン画面で作成済みユーザーのメールアドレスとパスワードを入力した時' do
      let(:email) { user.email }
      let(:password) { user.password }

      example '正常にログインできる' do
        expect(page).to have_content 'ログインしました'
      end
    end

    context 'ログイン画面で作成済みユーザーと該当しないメールアドレスとパスワードを入力した時' do
      let(:email) { 'foo' }
      let(:password) { 'bar' }

      example 'ログイン画面が表示される' do
        expect(page).to have_selector 'h1', text: 'ログイン'
      end
    end
  end

  describe 'ログアウト機能' do
    context 'ログイン済みの時' do
      let(:email) { user.email }
      let(:password) { user.password }

      before do
        click_link 'ログアウト'
      end

      example '正常にログアウトできる' do
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end
end
