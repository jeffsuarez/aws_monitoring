class EC2Client
  def initialize(attributes = {})
    @region = attributes[:region]
    @credentials = attributes[:credentials]
  end

  def can_describe_instances?
    begin
      client.describe_instances(dry_run: true)
    rescue Aws::EC2::Errors::DryRunOperation
      return true
    rescue => e
      return false
    end
    return false
  end

  private

  def client
    @ec2_client ||= Aws::EC2::Client.new(
      region: @region,
      credentials: @credentials
    )
  end
end