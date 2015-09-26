class EC2PermissionsValidator < ActiveModel::Validator
  def validate(record)
    if record.aws_access_key_id.present? && record.aws_secret_key.present?
      ec2_client = record.send(options[:client])
      if not ec2_client.can_describe_instances?
        record.errors[:base] << "You do not have permission to access the EC2 API"
      end
    end
  end
end
