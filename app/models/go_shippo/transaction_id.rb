class GoShippo::TransactionId < ActiveRecord::Base
  include HTTParty

  def self.get(transaction_obj)
    HTTParty.get(base_path+base_url(transaction_obj),
              :headers => { 'Content-Type' => 'application/x-www-form-urlencoded' , 'Authorization' => "ShippoToken #{Spree::Store.first.goshippo_api}"} )

  end

  private

  def self.base_path
    Spree::Store.first.goshippo_base_api_url
  end
  def self.base_url(transaction_obj)
     "/transactions/#{transaction_obj}"
  end

end