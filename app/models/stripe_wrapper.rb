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

  class Customer
    attr_reader :error_message

    def self.create(options = {})
      begin
        response = Stripe::Customer.create(
          :email => options[:user].email,
          :plan => 'base',
          :card => options[:card]
        )

        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def initialize(options = {})
      @response = options[:response]
      @error_message = options.fetch(:error_message) { '' }
    end

    def successful?
      @response.present?
    end
  end
end
