Spree::Admin::OrdersHelper.class_eval do
	def shipment_label_url(shipment_id)
		record = Goshippoid.find_by_spree_shipment_id(shipment_id)
		url = record ? record.label_url : ""
	end

	def shipment_return_label_url(shipment_id)
		record_return = Goshippoid.find_by_spree_shipment_id(shipment_id)
		return_url = record_return ? record_return.return_label_url : ""
	end

end