require 'byebug'

module XRoad
  class MissingXRoadHeadAttribute < ArgumentError; end

  class ActiveXRoad6
    class << self
      attr_accessor :user_id
      attr_accessor :ser_class, :ser_member_code, :ser_system, :ser_service_code, :ser_version

      # Returns list of methods what service provider allows
      #
      # Usage example: 
      #   XRoad::Rr.allowed_methods
      #   XRoad::Ehis.allowed_methods
      #
      def allowed_methods
        request service_path: producer_path + '/allowedMethods/v1'
      end

      def config
        @config ||= XRoad.configuration
      end

      def service_path=(path)
        self.ser_class, 
          self.ser_member_code, 
          self.ser_system, 
          self.ser_service_code, 
          self.ser_version = path.split('/')
      end

      def uuid
        UUIDTools::UUID.random_create.to_s.delete!('-')
      end

      def producer_ns
        "http://#{ser_system}.x-road.eu/producer"
      end

      def header
        {
          'xroad:protocolVersion': '4.0',
          'xroad:id': uuid,
          'xroad:userId': user_id,
          'xroad:service': {
            '@id:objectType':    'SERVICE',
            'id:xRoadInstance':  config.x_road_instance, 
            'id:memberClass':    ser_class,
            'id:memberCode':     ser_member_code,
            'id:subsystemCode':  ser_system,
            'id:serviceCode':    ser_service_code,
            'id:serviceVersion': ser_version
          },
          'xroad:client': {
            '@id:objectType':   'SUBSYSTEM',
            'id:xRoadInstance': config.x_road_instance,
            'id:memberClass':   config.client_member_class,
            'id:memberCode':    config.client_member_code,
            'id:subsystemCode': config.client_subsystem_code
          }
        }
      end

      def request(service_path:, ns: nil, action: nil, body: nil, user_id: nil)
        self.user_id = user_id
        self.service_path = service_path
        action ||= ser_service_code
        ns ||= producer_ns
        client = create_client(ns)

        response = if XRoad.through_proxy?
                     request_through_proxy(client, action, header, body)
                   else
                     client.call(action, soap_header: header, message: body)
                   end

        response.body
      end

      def request_through_proxy(client, action, header, body)
        proxy_credentials = "#{XRoad.configuration.proxy_username}:#{XRoad.configuration.proxy_password}"
        header['Proxy-Authorization'] = "Basic #{proxy_credentials}"
        client.call(action, soap_header: header, message: body)
      end

      def create_client(ns)
        config = XRoad.configuration
        Savon.client do
          if XRoad.through_proxy?
            proxy XRoad.configuration.proxy_address
          end
          endpoint config.host
          ssl_cert_file config.client_cert
          ssl_cert_key_file config.client_key
          pretty_print_xml true
          ssl_verify_mode config.ssl_verify
          log true
          log_level config.log_level
          env_namespace 'SOAP-ENV'
          namespace_identifier 'producer'
          namespace ns
          namespaces(
            'xmlns:xroad': 'http://x-road.eu/xsd/xroad.xsd',
            'xmlns:id': 'http://x-road.eu/xsd/identifiers',
            'xmlns:SOAP-ENC': 'http://schemas.xmlsoap.org/soap/encoding/'
          )
        end
      end
    end

    def to_json
    end
  end
end
