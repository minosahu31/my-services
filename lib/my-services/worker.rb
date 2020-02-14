module MyServices
  class Worker < MyServicesObject
    include MyServices::Actions::Post

    def self.api_url
      'billspayment/bill'
    end
  end
end

