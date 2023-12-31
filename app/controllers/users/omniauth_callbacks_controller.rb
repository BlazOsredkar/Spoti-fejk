# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  def github
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.github_data"] = request.env["omniauth.auth"]
      existing_provider = @user.provider if @user.present?
      if existing_provider.present?
        redirect_to new_user_session_path, notice: "You already have a login with another provider"
      else
        redirect_to new_user_session_path, notice: "error."
      end
    end
  end

  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
      existing_provider = @user.provider if @user.present?
      if existing_provider.present?
        redirect_to new_user_session_path, notice: "You already have a login with another provider"
      else
        redirect_to new_user_session_path, notice: "error."
      end
    end
  end

  def failure
    redirect_to new_user_session_path, notice: "You already have a login with another provider."
  end


  def google_oauth2
    user = User.from_omniauth(auth)

    if user.present?
      sign_out_all_scopes
      flash[:success] = "Signed in successfully via Google!"
      sign_in_and_redirect user, event: :authentication
    else
      flash[:alert] = "Error signing in via Google. Please try again."
      existing_provider = @user.provider if @user.present?
      if existing_provider.present?
        redirect_to new_user_session_path, notice: "You already have a login with another provider (#{existing_provider})."
      else
        redirect_to new_user_session_path, notice: "error."
      end
    end
  end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  private

  def auth
    @auth ||= request.env['omniauth.auth']
  end

end
