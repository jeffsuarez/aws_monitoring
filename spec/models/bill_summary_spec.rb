require 'spec_helper'

describe EC2Client do
  describe 'can_describe_instances?' do
    it 'calls describe_instances on the ec2 client' do
      ec2_client = double
      expect(ec2_client).to receive(:describe_instances).once

      allow_any_instance_of(EC2Client).to receive(:client).and_return(ec2_client)
      client = EC2Client.new(aws_access_key_id: '123', aws_secret_key: '456', region: 'us-east-1')

      client.can_describe_instances?
    end
  end
end