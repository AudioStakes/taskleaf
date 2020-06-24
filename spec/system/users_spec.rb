require 'rails_helper'

describe 'ユーザー管理機能', type: :system do
  let!(:admin_user) { FactoryBot.create(:admin_user, name: '管理者ユーザー', email: 'admin@example.com') }
  let!(:non_admin_user) { FactoryBot.create(:user, name: '非管理者ユーザー', email: 'non_admin@example.com') }

  before do
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログインする'
  end

  describe 'ナビゲーションバー' do
    context '管理者ユーザーがログインしているとき' do
      let(:login_user) { admin_user }

      example 'ユーザー一覧画面へのリンクが表示される' do
        expect(page).to have_link 'ユーザー一覧'
      end
    end

    context '非管理者ユーザーがログインしているとき' do
      let(:login_user) { non_admin_user }

      example 'ユーザー一覧画面へのリンクが表示されない' do
        expect(page).to have_no_link 'ユーザー一覧'
      end
    end
  end

  describe '一覧表示機能' do
    before do
      visit admin_users_path
    end

    context '管理者ユーザーがログインしているとき' do
      let(:login_user) { admin_user }

      example 'ユーザー一覧が表示される' do
        expect(page).to have_content '管理者ユーザー'
        expect(page).to have_content '非管理者ユーザー'
      end
    end

    context '非管理者ユーザーがログインしているとき' do
      let(:login_user) { non_admin_user }

      example 'トップ画面へリダイレクトされる' do
        expect(page).to have_content 'タスク一覧'
      end
    end
  end

  describe '詳細表示機能' do
    context '管理者ユーザーがログインしているとき' do
      let(:login_user) { admin_user }

      before do
        visit admin_user_path(admin_user)
      end

      example 'ユーザーの詳細が表示される' do
        expect(page).to have_content '管理者ユーザー'
      end
    end
  end

  describe '新規作成機能' do
    let(:login_user) { admin_user }
    let(:user_name) { 'テストユーザー' }
    let(:user_mail) { 'test@example.com' }
    let(:user_password) { 'password' }
    let(:user_password_confirm) { 'password' }

    before do
      visit new_admin_user_path
      fill_in '名前', with: user_name
      fill_in 'メールアドレス', with: user_mail
      fill_in 'パスワード', with: user_password
      fill_in 'パスワード（確認）', with: user_password_confirm
      click_button '登録する'
    end

    context '名前、メールアドレス、パスワード、パスワード（確認）を入力したとき' do
      example '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: 'ユーザー「テストユーザー」を登録しました'
      end
    end

    context '名前を入力しなかったとき' do
      let(:user_name) { '' }

      example '名前未入力のエラーとなる ' do
        expect(page).to have_content '名前を入力してください'
      end
    end

    context 'メールアドレスを入力しなかったとき' do
      let(:user_mail) { '' }

      example 'メールアドレス未入力のエラーとなる ' do
        expect(page).to have_content 'メールアドレスを入力してください'
      end
    end

    context 'パスワードとパスワード（確認）を入力しなかったとき' do
      let(:user_password) { '' }
      let(:user_password_confirm) { '' }

      example 'パスワード未入力のエラーとなる ' do
        expect(page).to have_content 'パスワードを入力してください'
      end
    end

    context 'パスワードとパスワード（確認）が一致しなかったとき' do
      let(:user_password) { 'foo' }
      let(:user_password_confirm) { 'bar' }

      example 'パスワード不一致のエラーとなる ' do
        expect(page).to have_content 'パスワード（確認）とパスワードの入力が一致しません'
      end
    end
  end
end
