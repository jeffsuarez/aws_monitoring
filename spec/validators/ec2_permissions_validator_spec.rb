require 'spec_helper'

describe EC2PermissionsValidator do
  describe '#validate' do
    example_class = Class.new do
      include ActiveModel::Validations
      attr_accessor :aws_access_key_id, :aws_secret_key, :can_describe_instances

      def can_describe_instances?
        can_describe_instances
      end
    end

    it 'should add an error when the credentials are invalid' do
      record = example_class.new
      record.aws_access_key_id = '111'
      record.aws_secret_key = '222'
      record.can_describe_instances = false

      validator = EC2PermissionsValidator.new
      validator.validate(record)

      expect(record.errors.messages[:base]).to eq(['You do not have permission to access the EC2 API'])
    end
    it 'should not add an error if the credentials are valid' do
      record = example_class.new
      record.aws_access_key_id = '111'
      record.aws_secret_key = '222'
      record.can_describe_instances = true

      validator = EC2PermissionsValidator.new
      validator.validate(record)

      expect(record.errors.messages[:base]).to be_nil
    end
    it 'should not call the ec2 client API if both fields arent present' do
      record = example_class.new
      record.aws_access_key_id = '111'
      record.can_describe_instances = true

      validator = EC2PermissionsValidator.new

      expect(record).not_to receive(:can_describe_instances?)

      validator.validate(record)
    end
  end
end