# NB! after upgrade to V6, not tested in test nor in production
module XRoad
  class Kpr < XRoad::ActiveXRoad6
    class << self
      def producer_path
        'COM/14282597/kpr'
      end

      def laekumised_maksuametist(personal_code, user_id:)
        service_path = producer_path + '/laekumised_maksuametist/v1'
        body = {
          keha: {
            isikukood: personal_code
          }
        }
        response = request service_path: service_path, body: body, user_id: user_id 
        response[:laekumised_maksuametist_response][:keha]
      end
    end
  end
end
