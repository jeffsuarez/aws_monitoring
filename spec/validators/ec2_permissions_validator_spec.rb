require 'spec_helper'

describe EC2PermissionsValidator do
  describe '#validate' do
    example_class = Class.new do
      include ActiveModel::Validations
      attr_accessor :aws_access_key_id, :aws_secret_key, :ec2_client
    end

    it 'should add an error when the credentials are invalid' do
      record = example_class.new
      record.aws_access_key_id = '111'
      record.aws_secret_key = '222'
      record.ec2_client = instance_double(
        'EC2Client',
        'can_describe_instances?' => false
      )
      validator = EC2PermissionsValidator.new(client: :ec2_client)

      validator.validate(record)

      expect(record.errors.messages[:base]).to eq(['You do not have permission to access the EC2 API'])
    end
    it 'should not add an error if the credentials are valid' do
      record = example_class.new
      record.aws_access_key_id = '111'
      record.aws_secret_key = '222'
      record.ec2_client = instance_double(
        'EC2Client',
        'can_describe_instances?' => true
      )
      validator = EC2PermissionsValidator.new(client: :ec2_client)

      validator.validate(record)

      expect(record.errors.messages[:base]).to be_nil
    end
    it 'should not call the ec2 client API if both fields arent present' do
      record = example_class.new
      record.aws_access_key_id = '111'
      ec2_client = instance_double(
        'EC2Client',
        'can_describe_instances?' => true
      )
      record.ec2_client = ec2_client
      validator = EC2PermissionsValidator.new(client: :ec2_client)

      expect(ec2_client).not_to receive(:can_describe_instances?)

      validator.validate(record)
    end
  end
end