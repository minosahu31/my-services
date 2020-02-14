module MyServices
  module Actions
    module Post
      module ClassMethods

        def load_category
          api_url = "#{api_url}/categories"
          response = MyServices.request(api_url, :post)
        end
        
        def load_billers(id)
          api_url = "#{api_url}/getbillers/#{id}"
          response = MyServices.request(api_url, :post)
        end 
        
        # params - id, customerRef, billerId, narration, accountNumber, paymentDate
        def do_payment(payment_data)
          api_url = "#{self.api_url}/dopayment"
          response = MyServices.request(api_url, :post, payment_data)
        end
        
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

