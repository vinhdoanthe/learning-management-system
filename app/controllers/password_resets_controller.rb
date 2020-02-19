class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User::User.find_by(username: params[:password_reset][:username].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:success] = "Email sent with password reset instructions"
      # TODO: render view after send mail success
      redirect_to root_url
    else
      flash.now[:danger] = "Username not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user_user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to root_path
    else
      render 'edit'
    end
  end


  private

  def get_user
    @user = User::User.find_by(username: params[:username])
  end

  # Confirms a valid user.
  def valid_user
    unless (@user && @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end

  def user_params
    params.require(:user_user).permit(:password, :password_confirmation)
  end


  # Checks expiration of reset token.
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end

end
