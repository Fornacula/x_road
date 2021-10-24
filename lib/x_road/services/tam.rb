module XRoad
  # Terviseamet (Health Board)
  class Tam < XRoad::ActiveXRoad6
    class << self
      def producer_path
        'GOV/70008799​/tam'
        # 'GOV/70009770/digilugu'
      end

      def allowed_methods
        request service_path: producer_path + '/allowedMethods'
      end

      def list_methods
        request service_path: producer_path + '/listMethods'
      end

      def registriisik(personal_code)
        service_path = producer_path + '/registriisik/v1'
        body = {
          isikukood: personal_code
        }
        request service_path: service_path, body: body, user_id: user_id
      end
    end
  end
end