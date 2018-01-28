Spree::Shipment.class_eval do
	has_one :SpreeShippingLabel
	has_one :Goshippoid
end