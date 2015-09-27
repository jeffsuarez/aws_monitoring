class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :verify_aws_credentials

  helper_method :body_class

  private

  def verify_aws_credentials
    if session[:aws_access_key_id].present? && session[:aws_secret_key].present?
      @session = Session.new(
        aws_access_key_id: session[:aws_access_key_id],
        aws_secret_key: session[:aws_secret_key],
        s3_billing_bucket: session[:s3_billing_bucket]
      )
    end
  end

  def body_class
    qualified_controller_name = controller_path.gsub('/','-')
    basic_body_class = "#{qualified_controller_name} #{qualified_controller_name}-#{action_name}"
  end
end
