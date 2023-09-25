# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  def new
    @user = User.new
  end

  def create
    self.resource = User.find_by(email: params[:user][:email])

    if resource
      # Generate and save the OTP
      resource.generate_otp
      resource.generate_otp_token # Generate a unique OTP token
      resource.save

      # Send the OTP email with verification link
      otp_verification_url = otp_verification_url(token: resource.otp_token)
      UserMailer.send_otp_email(resource, otp_verification_url).deliver_now

      set_flash_message!(:notice, :signed_in)
      session[:email] = resource.email
      redirect_to otp_verification_path, notice: "OTP sent to your email."
    else
      # Handle the case where the email address was not found
      flash.now[:alert] = "Email address not found."
      render :new
    end
  end

  def otp_verification
    @user = User.find_by(email: session[:email])
  end

  def verify_otp
    email = params[:user][:email]
    @user = User.find_by(email: params[:user][:email])

    if @user && @user.valid_otp?(params[:user][:otp]) && @user.valid_password?(params[:user][:password])
      sign_in(resource_name, @user)
      set_flash_message!(:notice, :signed_in)
      
      # Set the OTP verification flag to true
      @otp_verified = true

      redirect_to root_path, notice: "Logged in successfully"
    else
      flash[:alert] = "Invalid OTP. Please try again."
      render :otp_verification, locals: { email: email, user: @user }
    end
  end

  # omniauth login using google
  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end


  # DELETE /resource/sign_out
  # def destroy
  #   session[:user_id] = nil
  #   redirect_to root_path, flash: { success: 'Logged Out' }
  # end

  #protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :otp])
  end
end
