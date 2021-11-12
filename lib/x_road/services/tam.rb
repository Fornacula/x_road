module XRoad
  # Tam is a subsystem managed by Terviseamet's (Health Board)
  # IT-branch TEHIK.
  class Tam < XRoad::ActiveXRoad6
    class << self
      def producer_path
        'GOV/70008799/tam'
      end

      def registriisik(personal_code)
        service_path = producer_path + '/registriisik/v1'
        body = {
          isikukood: personal_code
        }
        request service_path: service_path, body: body
      end
    end
  end
end
