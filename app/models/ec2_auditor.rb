class EC2Auditor
  def initialize
    @ec2_client = attributes[:ec2_client]
  end

  def instances_without_reservations
    parsed_instances.select { |i| not i.covered? }
  end

  def parsed_instances
    unless @parsed_instances do
      active_instances.reservations.each do |reservation|
        reservation.instances.each do |instance|
          @parsed_instances << AuditedEC2Instance.new(
            type: instance.instance_type,
            availability_zone: instance.placement.availability_zone,
            platform: instance.platform,
            reserved: false
          )
        end
      end
    return @parsed_instances
  end

  def active_instances
    @active_instances ||= @ec2_client.describe_instances(
      filters: [
        { name: "instance-state-name", values: ["running"] }
      ]
    )
  end
end

class AuditedEC2Instance
  attr_accesor :type, :availability_zone, :platform, :reserved

  def initialize(attributes= {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
end