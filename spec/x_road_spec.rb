require 'spec_helper'

describe XRoad do
  context '#configure' do
    it 'has default values configured' do
      expect(XRoad.configuration.log_level).to eql(:info)
    end

    it 'should populate all client path attributes' do
      XRoad.configure do |config|
        config.client_path = 'ee-test/NGO/90005872/harid'
      end

      conf = XRoad.configuration
      expect(conf.x_road_instance).to eql('ee-test')
      expect(conf.client_x_road_instance).to eql('ee-test')
      expect(conf.client_member_class).to eql('NGO')
      expect(conf.client_member_code).to eql('90005872')
      expect(conf.client_subsystem_code).to eql('harid')
    end
  end

  context 'With proxy-server' do
    it 'knows by conf params if proxy needed' do
      XRoad.configure do |config|
        config.proxy_address = 'sth.sth.sth'
        config.proxy_username = 'username'
        config.proxy_password = 'pa55W0rd.'
      end

      expect(XRoad.through_proxy?).to be_truthy
    end

    it 'understands proxy not needed if all proxy conf params missing' do
      XRoad.configure do |config|
        config.proxy_address = nil
        config.proxy_username = nil
        config.proxy_password = nil
      end

      expect(XRoad.through_proxy?).to be_falsey
    end

    it 'understands proxy not needed if proxy conf params partially missing' do
      XRoad.configure do |config|
        config.proxy_address = nil
        config.proxy_username = 'username'
        config.proxy_password = 'pa55W0rd.'
      end

      expect(XRoad.through_proxy?).to be_falsey
    end
  end
end
