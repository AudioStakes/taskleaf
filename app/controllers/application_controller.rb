class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login_required
  # before_action :set_locale  # 未実装
  # rescue_from MyCustomError, with: show_custom_error_page # アプリケーション固有エラー処理の追加（未実装）

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_url unless current_user
  end

  # 以下を動作させるために、Userモデルにlocaleカラムを追加する必要あり
  # def set_locale
  #   I18n.locale = current_user&.locale || :ja #ログインしていなければ日本語
  # end

  # アプリケーション固有エラー処理の追加（未実装、custom_error.html.slim というエラー画面用テンプレートを作成する必要あり）
  # def show_custom_error_page(error)
  #   @error = error
  #   render = :custom_error
  # end
end
