class Spree::Admin::GoshipmentsController < Spree::Admin::BaseController
  def create_parcel
    begin
      shipping_label = SpreeShippingLabel.find(params[:spree_shipping_label_id])
      shippo_parcel = shipping_label.create_shippo_parcel(params[:weight], params[:mass_unit])
      shipment = Spree::Shipment.find(params[:shipment_id])
      order = Spree::Order.find(shipment.order_id)
      shippo = Goshippoid.find_or_create_by(spree_shipment_id: shipment.id)
      shippo.update_attributes(parcel_object_id: shippo_parcel['object_id'])
      parcel = shippo_parcel['object_id']
      if order.approved?
        bill_address = order.ship_address
        ship_address = order.line_items.last.variant.stock_locations.last
        address_to = bill_address.create_shippo_address('PURCHASE', params[:Residential_recipient], order.user.email)
        address_from = ship_address.create_shippo_address('PURCHASE', params[:Residential_recipient], order.user.email)
        submition_date = (params['shipment_date'].to_time).utc.iso8601
        go_shippo_shipment = GoShippo::Shipment.create('PURCHASE', address_from, address_to, parcel, 'DROPOFF', submition_date, params[:insurance_amount], params[:insurance_currency], params[:Add_signature_confirmation])
        shippo.update_attributes(shipment_obj_id: go_shippo_shipment['object_id'])
        @goshippo_ratelist = GoShippo::Rate.get(shippo.shipment_obj_id)
        if @goshippo_ratelist['count'] == 0
          redirect_to :back, flash: { error: 'Invalid Order Details' }
        end
      end
    rescue Exception => e
      redirect_to :back, flash: { error: 'SomeThing went Wrong. Please Try Again' }
    end
  end

  def transactions
    begin
      transaction_object = GoShippo::Transaction.create(params['object_id'])
      shipment = Spree::Shipment.find(params[:shipment_id])
      shippo = Goshippoid.find_by_spree_shipment_id(shipment.id)
      shippo.update_attributes(transaction_obj_id: transaction_object['object_id'])
      @transactions_ship = GoShippo::TransactionId.get(shippo.transaction_obj_id)
      if @transactions_ship['messages'].present?
        redirect_to admin_orders_path, notice: @transactions_ship['messages'][0]['text']
      else
        shipment.update_attributes(tracking: @transactions_ship['tracking_url_provider'])
        shippo.update_attributes(label_url: @transactions_ship['label_url'])
      end  
    rescue Exception => e
      redirect_to :back, flash: { error: 'SomeThing went Wrong. Please Try Again' }      
    end
  end

  def return_label
    shipping_label = SpreeShippingLabel.find(params[:spree_shipping_label_id])
    shippo_parcel = shipping_label.create_shippo_parcel(params[:weight], params[:mass_unit])
    shipment = Spree::Shipment.find(params[:shipment_id])
    order = Spree::Order.find(shipment.order_id)
    shippo = Goshippoid.find_or_create_by(spree_shipment_id: shipment.id)
    shippo.update_attributes(parcel_object_id: shippo_parcel['object_id'])
    parcel = shippo_parcel['object_id']
    bill_address = order.ship_address
    ship_address = order.line_items.last.variant.stock_locations.last
    address_to = bill_address.create_shippo_address('PURCHASE', params[:Residential_recipient], order.user.email)
    address_from = ship_address.create_shippo_address('PURCHASE', params[:Residential_recipient], order.user.email)
    return_of = shippo['transaction_obj_id']
    submition_date = (params['shipment_date'].to_time).utc.iso8601
    go_shippo_return_shipment = GoShippo::ReturnLabel.create('PURCHASE', address_from, address_to, parcel, 'PICKUP', return_of, submition_date, params[:insurance_amount], params[:insurance_currency])
    shippo.update_attributes(return_shipment_obj_id: go_shippo_return_shipment['object_id'])
    @goshippo_ratelist = GoShippo::Rate.get(shippo.return_shipment_obj_id)
    if @goshippo_ratelist['count'] == 0
      redirect_to :back, flash: { error: 'Invalid Order Details' }
    end
  end

  def return_transactions
    begin
      transaction_object = GoShippo::Transaction.create(params['object_id'])
      shipment = Spree::Shipment.find(params[:shipment_id])
      shippo = Goshippoid.find_by_spree_shipment_id(shipment.id)  
      shippo.update_attributes(transaction_obj_id: transaction_object['object_id'])
      @transactions_ship = GoShippo::TransactionId.get(shippo.transaction_obj_id)
      if @transactions_ship['messages'].present?
        redirect_to admin_orders_path, notice: @transactions_ship['messages'][0]['text']
      else
        shippo.update_attributes(return_label_url: @transactions_ship['label_url'])
      end  
    rescue Exception => e
      redirect_to :back, flash: { error: 'SomeThing went Wrong. Please Try Again' }      
    end
  end

  def refund
    shipment = Spree::Shipment.find(params[:shipment_id])
    shippo = Goshippoid.find_by_spree_shipment_id(params[:shipment_id])
    @refund = GoShippo::Refund.create(shippo.transaction_obj_id)
    if @refund['object_id'].present?
      shippo.update_attributes(refund_object_id: @refund['object_id'], return_label_url: "", label_url: "")
      shipment.update_attributes(tracking: "")
      flash[:notice] = "Refund inditiated"
    else
      notice = @refund[:transaction]
    end
      redirect_to admin_orders_path, flash: {error: notice}
  end
end