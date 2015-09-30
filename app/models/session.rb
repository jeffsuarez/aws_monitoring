class Session
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :aws_access_key_id, :aws_secret_key, :region, :s3_billing_bucket

  validates_length_of :aws_access_key_id, minimum: 16, maximum: 32
  validates_presence_of :aws_secret_key
  validates_with EC2PermissionsValidator


  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def to_param
    @aws_access_key_id
  end

  def valid?
    super && can_describe_instances?
  end

  def persisted?
    false
  end

  def account_number
    @account_number ||= begin
      arn = iam_client.get_user().user.arn
      arn.split(":user").first.split("iam::").last
    rescue
      nil
    end
  end

  def bill_summary
    @bill_summary ||= BillSummary.new(
      s3_client: s3_client,
      s3_billing_bucket: s3_billing_bucket,
      account_number: account_number
    )
  end

  def can_describe_instances?
    begin
      ec2_client.describe_instances(dry_run: true)
    rescue Aws::EC2::Errors::DryRunOperation
      return true
    rescue => e
      return false
    end
    return false
  end


  def ec2_client
    @ec2_client ||= Aws::EC2::Client.new(config_params)
  end

  def s3_client
    @s3_client ||= Aws::S3::Client.new(config_params)
  end

  def iam_client
    @iam_client ||= Aws::IAM::Client.new(config_params)
  end

  def credentials
    @credentials ||= Aws::Credentials.new(aws_access_key_id, aws_secret_key)
  end

  def config_params
    { credentials: credentials, region: region }
  end
end
