class CreateGoshippoids < ActiveRecord::Migration
  def change
    create_table :goshippoids do |t|
      t.integer :spree_shipment_id
      t.string :parcel_object_id
      t.string :shipment_obj_id
      t.string :transaction_obj_id
      t.string :label_url
	    t.string :return_shipment_obj_id
	    t.string :return_label_url
      t.string :refund_object_id
      t.timestamps null: false
    end
  end
end