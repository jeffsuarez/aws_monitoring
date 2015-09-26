class Session
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :aws_access_key_id, :aws_secret_key, :region

  validates_length_of :aws_access_key_id, minimum: 16, maximum: 32
  validates_presence_of :aws_secret_key
  validates_with EC2PermissionsValidator, client: :ec2_client


  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def to_param
    @aws_access_key_id
  end

  def valid?
    super && ec2_client.can_describe_instances?
  end

  def persisted?
    false
  end

  def ec2_client
    @ec2_client ||= EC2Client.new(
      aws_access_key_id: @aws_access_key_id,
      aws_secret_key: @aws_secret_key,
      region: @region
    )
  end
end
