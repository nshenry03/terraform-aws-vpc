# See
# * [Example|http://bit.ly/2GqgA9P]
# * [Documentation|https://github.com/k1LoW/awspec]

require 'awspec'
require 'aws-sdk'
require 'rhcl'

number_availability_zones = 2
intra_subnets = %w(db intra)
private_subnets = intra_subnets + %w(private)

example_main = Rhcl.parse(File.open('examples/test_fixture/main.tf'))

environment_tag = example_main['module']['vpc']['tags']['Environment']
user_tag = ENV['TF_VAR_user'] || 'user'
vpc_name = "#{user_tag}-vpc-mod"
cidr = example_main['module']['vpc']['cidr']

state_file = './terraform.tfstate.d/kitchen-terraform-default-aws/terraform.tfstate'
tf_state = JSON.parse(File.open(state_file).read)

region = tf_state['modules'][0]['outputs']['region']['value']
ENV['AWS_REGION'] = region

ec2 = Aws::EC2::Client.new(region: region)
azs = ec2.describe_availability_zones
zone_names = azs.to_h[:availability_zones].first(number_availability_zones).map { |az| az[:zone_name] }


describe vpc(vpc_name.to_s) do
  it { should exist }
  it { should be_available }
  it { should have_tag('Name').value(vpc_name.to_s) }
  it { should have_tag('Owner').value(user_tag.to_s) }
  it { should have_tag('Environment').value(environment_tag.to_s) }
  it { should have_route_table("#{vpc_name}-public") }
  private_subnets.each do |subnet|
    zone_names.each do |az|
      it { should have_route_table("#{vpc_name}-#{subnet}-#{az}") }
    end
  end
end

(['public'] + private_subnets).each do |subnet|
  zone_names.each do |az|
    describe subnet("#{vpc_name}-#{subnet}-#{az}") do
      it { should exist }
      it { should be_available }
      it { should belong_to_vpc(vpc_name.to_s) }
      it { should have_tag('Name').value("#{vpc_name}-#{subnet}-#{az}") }
      it { should have_tag('Owner').value(user_tag.to_s) }
      it { should have_tag('Environment').value(environment_tag.to_s) }
    end
  end
end

describe route_table("#{vpc_name}-public") do
  it { should exist }
  it { should have_route('0.0.0.0/0').target(gateway: vpc_name.to_s) }
  it { should have_route(cidr.to_s).target(gateway: 'local') }
  zone_names.each do |az|
    it { should have_subnet("#{vpc_name}-public-#{az}") }
  end
end

zone_names.each do |az|
  nat_gateway = ec2.describe_nat_gateways(
    {
      filter: [
        {
          name: "tag:Name",
          values: ["#{vpc_name}-#{az}"],
        },
        {
          name: "state",
          values: ["available"],
        },
      ]
    }
  )

  describe route_table("#{vpc_name}-private-#{az}") do
    it { should exist }
    it { should have_route('0.0.0.0/0').target(nat: nat_gateway.to_h[:nat_gateways][0][:nat_gateway_id]) }
    it { should have_route(cidr.to_s).target(gateway: 'local') }
    it { should have_subnet("#{vpc_name}-private-#{az}") }
  end

  intra_subnets.each do |subnet|
    describe route_table("#{vpc_name}-#{subnet}-#{az}") do
      it { should exist }
      it { should have_route(cidr.to_s).target(gateway: 'local') }
      it { should_not have_route('0.0.0.0/0') }
      it { should have_subnet("#{vpc_name}-#{subnet}-#{az}") }
    end
  end
end
