class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :verify_aws_credentials

  helper_method :body_class


  private

  def verify_aws_credentials
    unless session[:aws_access_key_id] && session[:aws_secret_key]
      redirect_to new_session_path
    end
  end

  def body_class
    qualified_controller_name = controller_path.gsub('/','-')
    basic_body_class = "#{qualified_controller_name} #{qualified_controller_name}-#{action_name}"
  end
end
