class Session
  include ActiveModel::Validations

  attr_accessor :aws_access_key_id, :aws_secret_key

  validates_length_of :aws_access_key_id, minimum: 16, maximum: 32
  validates_presence_of :aws_secret_key

  def initialize(params = {})
    @aws_access_key_id = params[:aws_access_key_id]
    @aws_secret_key = params[:aws_secret_key]
    @region = params[:region]
  end

  def to_param
    @aws_access_key_id
  end

  def valid?
    super && can_describe_instances?
  end

  def ec2_client
    @ec2_client ||= Aws::EC2::Client.new(
      region: @region,
      credentials: Aws::Credentials.new(@aws_access_key_id, @aws_secret_key)
    )
  end

  private

  def can_describe_instances?
    begin
      ec2_client.describe_instances(dry_run: true)
    rescue Aws::EC2::Errors::DryRunOperation
      return true
    rescue
      return false
    end
    return false
  end
end