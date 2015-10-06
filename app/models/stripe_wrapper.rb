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

        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :failure)
      end
    end
    
    def self.set_api_key
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    end

    def initialize(response, status)
      @response = response
      @status = status
    end

    def successful?
      status == :success
    end

    def error_message
      response.message
    end
  end
end
