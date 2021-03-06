class InvoiceItem
  attr_reader :id,
              :item_id,
              :invoice_id,
              :quantity,
              :unit_price,
              :created_at,
              :updated_at,
              :repository

  def initialize(repository, data={})
    @repository = repository
    @id         = data[:id]
    @item_id    = data[:item_id]
    @invoice_id = data[:invoice_id]
    @quantity   = data[:quantity]
    @unit_price = data[:unit_price]
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
  end

  def revenue
    invoice.paid? ? (quantity * unit_price) : 0
  end

  def item
    @item ||= repository.find_item(item_id)
  end

  def invoice
    @invoice ||= repository.find_invoice(invoice_id)
  end
end
