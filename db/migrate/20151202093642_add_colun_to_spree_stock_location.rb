class AddColunToSpreeStockLocation < ActiveRecord::Migration
  def change
  	add_column :spree_stock_locations, :goshippo_address_obj, :string
  end
end
