require 'spec_helper'

describe XRoad do
  context '#configure' do
    it 'has default values configured' do
      XRoad.configuration.log_level.should == :info
    end

    it 'should populate all client path attributes' do
      XRoad.configure do |config|
        config.client_path = 'ee-test/NGO/90005872/harid'
      end

      conf = XRoad.configuration
      conf.x_road_instance.should == 'ee-test'
      conf.client_x_road_instance.should == 'ee-test'
      conf.client_member_class.should == 'NGO'
      conf.client_member_code.should == '90005872'
      conf.client_subsystem_code.should == 'harid'
    end
  end
end
