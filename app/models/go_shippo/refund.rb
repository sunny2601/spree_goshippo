class GoShippo::Refund < ActiveRecord::Base
  include HTTParty

  def self.body(transaction)
     "transaction=#{transaction}"
  end

  def self.create(transaction)
    HTTParty.post(base_path+base_url,
                  :body => self.body(transaction),
                  :headers => { 'Content-Type' => 'application/x-www-form-urlencoded' , 'Authorization' => "ShippoToken #{Spree::Store.first.goshippo_api}"} )
  end

  private

  def self.base_path
    Spree::Store.first.goshippo_base_api_url
  end
  def self.base_url
     "/refunds"
  end
end
