module XRoad
  class Ehis < XRoad::ActiveXRoad6
    class << self
      def producer_path
        'GOV/70000740/ehis'
      end

      # NS should be: 'http://rr.x-road.eu/producer' as V6 standard suggest, but
      # according to Ehis letter at 13.12.2017, ehis uses old one, thus we overwrite producer ns
      def producer_ns
        'http://producers.ehis.xtee.riik.ee/producer/ehis'
      end

      #
      # Example usage: 
      # XRoad::Ehis.isiku_rollid('60510319579', user_id: 'EE60510319579')
      # XRoad::Ehis.isiku_rollid('37803312007', user_id: 'EE37803312007')
      #
      def isiku_rollid(personal_code, user_id:)
        service_path = producer_path + '/isikuRollid/v1'
        body = {
          isikukood: personal_code
        }
        request service_path: service_path, body: body, user_id: user_id
      end

      #
      # Example usage: 
      # XRoad::Ehis.tervishoiuametile_oppurid('123', user_id: 'EE37803312007')
      #
      def tervishoiuametile_oppurid(ehis_code, user_id:)
        service_path = producer_path + '/tervishoiuametileOppurid/v1'
        body = {
          oasEhisKoodid: [
            oasEhisKood: ehis_code
          ]
        }
        request service_path: service_path, body: body, user_id: user_id
      end
    end
  end
end
