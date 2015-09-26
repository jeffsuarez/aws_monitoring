class SessionsController < ApplicationController
  skip_before_filter :verify_aws_credentials
  layout 'session'

  DEFAULT_REGION = 'us-east-1'

  def new
    @session = Session.new
  end

  def create
    @session = Session.new(session_params)

    if @session.valid?
      persist_session
      redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy
    session.delete(:aws_access_key_id)
    session.delete(:aws_secret_key)

    redirect_to new_session_path
  end

  private

  def persist_session
    session[:aws_access_key_id] = @session.aws_access_key_id
    session[:aws_secret_key] = @session.aws_secret_key
  end

  def session_params
    params.require(:session).permit(:aws_access_key_id, :aws_secret_key).merge(region: DEFAULT_REGION)
  end
end