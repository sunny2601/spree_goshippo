Spree::Address.class_eval do
	def create_shippo_address(trans_type, is_residential_param,email)
		is_residential = is_residential_param == 'true' ? 1 : 0
		address_obj=GoShippo::Address.create(self.full_name,trans_type,self.company, self.address1, self.address2, self.city,self.state ? self.state.abbr : self.state_name,self.zipcode,self.country.iso,self.alternative_phone,email, is_residential)

		self.goshippo_address_obj = address_obj['object_id']
		self.save
		self.goshippo_address_obj
	end
end