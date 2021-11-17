module XRoad
  # Tam is a subsystem managed by Terviseamet's (Health Board)
  # IT-branch TEHIK.
  class Tam < XRoad::ActiveXRoad6
    class << self
      def producer_path
        'GOV/70008799/tam'
      end

      # NS should be: 'http://rr.x-road.eu/producer' as V6 standard suggest, but
      # according to Ehis letter at 13.12.2017, ehis uses old one, thus we overwrite producer ns
      # def producer_ns
      #   'http://producers.tam.xtee.riik.ee/producer/tam'
      # end

      def registriisik(personal_code)
        service_path = producer_path + '/registriisik/v2'
        body = {
          isikukood: personal_code
        }
        request service_path: service_path, body: body
      end
    end
  end
end
