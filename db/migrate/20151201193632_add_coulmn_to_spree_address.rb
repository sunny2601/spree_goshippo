class AddCoulmnToSpreeAddress < ActiveRecord::Migration
  def change
  	add_column :spree_addresses, :goshippo_address_obj, :string
  end
end
