module XRoad
  # Population Register
  class Rr < XRoad::ActiveXRoad6
    class << self
      def producer_path
        'GOV/70008440/rr'
      end

      #
      # Example usage: XRoad::Rr.rr414('35001010036', user_id: 'EE35001010036')
      #
      # 1. Parent: 35001010036 SAMUEL LOOS,    child: 38612232328 AADAM LOOS
      # 2. Parent: 45001010015 TUULA JAHIPÜSS, child: 38411080248 GENNADI KROTOV
      # 3. Parent: 45012120015 OLGA TELIAMÄND, child: 48005050014 SIRJE TELIAMÄND
      # 4. Parent: 45307316010 LINDA KOVVALAI, child: 47811302727 ANNE PAINE
      #
      def rr414(personal_code, user_id:)
        service_path = producer_path + '/RR414/v3'
        body = {
          request: {
            isikukood: personal_code
          }
        }
        request service_path: service_path, body: body, ns: producer_ns, user_id: user_id
      end

      #
      # Example usage: XRoad::Rr.rr464('35001010036', user_id: 'EE35001010036')
      #
      # 1. Parent: 35001010036 SAMUEL LOOS,    child: 38612232328 AADAM LOOS
      # 2. Parent: 45001010015 TUULA JAHIPÜSS, child: 38411080248 GENNADI KROTOV
      # 3. Parent: 45012120015 OLGA TELIAMÄND, child: 48005050014 SIRJE TELIAMÄND
      # 4. Parent: 45307316010 LINDA KOVVALAI, child: 47811302727 ANNE PAINE
      #
      def rr464(personal_code, relation_type:, relation_status:, user_id:)
        service_path = producer_path + '/RR464isikuSuhted/v1'
        body = {
          request: {
            SuhteTyyp: relation_type,
            SuhteStaatus: relation_status,
            Isikukood: personal_code
          }
        }
        request service_path: service_path, body: body, ns: producer_ns, user_id: user_id
      end

    end
  end
end
