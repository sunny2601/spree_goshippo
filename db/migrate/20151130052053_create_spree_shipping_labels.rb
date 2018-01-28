class CreateSpreeShippingLabels < ActiveRecord::Migration
  def change
    create_table :spree_shipping_labels do |t|
      t.string :carrier
      t.string :parcel
      t.decimal :dimension_length
      t.decimal :dimension_height
      t.decimal :dimension_width
      t.string :dimension_unit
      t.string :weight
      t.string :mass_unit
      t.string :parcel_object_id
      t.string :shipment_object_id
      t.belongs_to :spree_order
      t.timestamps null: false
    end
  end
end
