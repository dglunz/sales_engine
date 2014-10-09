require 'date'
class Merchant
  attr_reader :id,
              :name,
              :created_at,
              :updated_at,
              :repository

  def initialize(repository, data={})
    @repository  = repository
    @id          = data[:id]
    @name        = data[:name]
    @created_at  = data[:created_at]
    @updated_at  = data[:updated_at]
  end

  def items
    repository.find_items_from(id)
  end

  def invoices
    repository.find_invoices_from(id)
  end

  def revenue(date="total")
    if date == "total"
      totals = invoices.map {|invoice| invoice.total}
    else
      daily_invoices = invoices.select {|invoice| Time.parse(invoice.created_at).to_date == date}
      totals = daily_invoices.map {|invoice| invoice.total}
    end
    totals.empty? ? 0 : totals.reduce(:+)
  end

  def total_items_sold
    totals = items.map { |item| item.invoice_items.count }
    totals.empty? ? 0 : totals.reduce(:+)
  end
end
