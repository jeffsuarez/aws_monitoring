class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :verify_aws_credentials

  protected

  def verify_aws_credentials
    unless session[:aws_access_key_id] && session[:aws_secret_key]
      redirect_to new_session_path
    end
  end
end
