class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    @back = root_path
    super
  end

  #POST /resource/sign_in
  #def create
  #  super do
  #    u = User.find_by_email(params[:user][:email])
  #    expiry = u.subscription_expiration
  #    if expiry.nil? || expiry + 7.days < DateTime.now
  #      sign_out u
  #      flash[:notice] = nil
  #      flash[:alert] = 'Subscription expired.'
  #    end
  #  end
  #end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
