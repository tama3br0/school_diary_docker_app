class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        if @user.additional_info_provided
          sign_in_and_redirect @user, event: :authentication
          flash[:notice] = 'ログイン しました！' # set_flash_messageの代わりに直接設定
        else
          sign_in @user
          redirect_to additional_info_path
          flash[:notice] = 'データを とうろく しよう！' # set_flash_messageの代わりに直接設定
        end
      else
        session['devise.google_data'] = request.env['omniauth.auth'].except(:extra)
        redirect_to new_user_registration_url, alert: 'ログインできませんでした。 おうちの人にきくか、 あした がっこうで せんせいに きいてね！'
      end
    end
end
