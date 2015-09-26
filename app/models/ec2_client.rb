class EC2Client
  def initialize(attributes = {})
    @region = attributes[:region]
    @aws_access_key_id = attributes[:aws_access_key_id]
    @aws_secret_key = attributes[:aws_secret_key]
    @credentials = Aws::Credentials.new(@aws_access_key_id, @aws_secret_key)
  end

  def can_describe_instances?
    begin
      client.describe_instances(dry_run: true)
    rescue Aws::EC2::Errors::DryRunOperation
      return true
    rescue
      return false
    end
    return false
  end

  private

  def client
    @ec2_client ||= Aws::EC2::Client.new(
      region: @region,
      credentials: Aws::Credentials.new(@aws_access_key_id, @aws_secret_key)
    )
  end
end