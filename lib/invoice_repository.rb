require_relative 'invoice'

class InvoiceRepository
  attr_reader :engine,
              :invoices

  def initialize(engine, invoices = [])
    @engine   = engine
    @invoices = invoices
  end

  [:id, :customer_id, :merchant_id, :status, :created_at, :updated_at].each do |attribute|
    define_method("find_by_#{attribute}") do |attribute_value|
      invoices.find { |object| object.send(attribute).to_s.downcase == attribute_value.to_s.downcase }
    end

    define_method("find_all_by_#{attribute}") do |attribute_value|
      invoices.select { |object| object.send(attribute).to_s.downcase == attribute_value.to_s.downcase }
    end
  end

  def all
    invoices
  end

  def random
    invoices.sample
  end

  def find_transactions(invoice_id)
    engine.find_all_transactions_by_invoice_id(invoice_id)
  end

  def find_invoice_items(invoice_id)
    engine.find_all_invoice_items_by_invoice_id(invoice_id)
  end

  def find_items_by_invoice_items(invoice_id)
    engine.find_all_items_by_invoice_id(invoice_id)
  end

  def find_by_customer(customer_id)
    engine.find_by_customer(customer_id)
  end

  def find_by_merchant(merchant_id)
    engine.find_by_merchant(merchant_id)
  end

  def inspect
    "#<#{self.class} #{invoices.size} rows>"
  end

  def create(customer:, merchant:, status: "success", items:)
    data = { id: invoices.last.id.to_i + 1, customer_id: customer.id.to_i, merchant_id: merchant.id.to_i, status: status, created_at: Time.now, updated_at: Time.now }
    invoice = Invoice.new(self, data)
    engine.create_invoice_items(invoice.id, items)
    invoices << invoice
    invoice
  end

  def charge(id, credit_card_number, credit_card_expiration_date, result)
    engine.create_transaction(id, credit_card_number, credit_card_expiration_date, result)
  end
end
