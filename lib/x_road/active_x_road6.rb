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
        response = client.call(action, soap_header: header, message: body)
        response.body
      end

      def create_client(ns)
        config = XRoad.configuration
        Savon.client do
          endpoint config.host
          if self.ssl_file_config?(config)
            ssl_cert_file config.client_cert_file
            ssl_cert_key_file config.client_key_file
          elsif self.ssl_string_config?(config)
            ssl_cert config.client_cert_string
            ssl_cert_key config.client_key_string
          end
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


      private

      def ssl_file_config?(config)
        defined?(config.client_cert_file) && defined?(config.client_key_file) && config.client_cert_file.present? && config.client_key_file.present?
      end

      def ssl_string_config?(config)
        defined?(config.client_cert_string) && defined?(config.client_key_string) && config.client_cert_string.present? && config.client_key_string.present?
      end
    end

    def to_json
    end
  end
end
