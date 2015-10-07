module StripeWrapper
  class Charge
    attr_reader :status, :response

    def self.create(options = {})
      begin
        response = Stripe::Charge.create(
                     amount: options[:amount], 
                     currency: 'usd', 
                     card: options[:card],
                     description: options[:description]
                   )

        new(response: response, status: :success)
      rescue Stripe::CardError => e
        new(response: e, status: :failure)
      end
    end
    
    def initialize(options = {})
      @response = options[:response]
      @status = options[:status]
    end

    def successful?
      status == :success
    end

    def error_message
      response.message
    end
  end
end
