class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        if @user.additional_info_provided
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :login_success) if is_navigational_format?
        else
          sign_in @user
          redirect_to additional_info_path
          set_flash_message(:notice, :additional_info_required) if is_navigational_format?
        end
      else
        session['devise.google_data'] = request.env['omniauth.auth'].except(:extra)
        redirect_to new_user_registration_url, alert: 'ログインできませんでした。 おうちの人にきくか、 あした がっこうで せんせいに きいてね！'
      end
    end
end
