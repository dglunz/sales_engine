class MerchantRepository

  attr_reader :merchants,
              :engine

  def initialize(engine, merchants = [])
    @engine    = engine
    @merchants = merchants
  end


  [:id, :name, :created_at, :updated_at].each do |attribute|
    define_method("find_by_#{attribute}") do |attribute_value|
      merchants.find { |object| object.send(attribute).to_s.downcase == attribute_value.to_s.downcase }
    end

    define_method("find_all_by_#{attribute}") do |attribute_value|
      merchants.select { |object| object.send(attribute).to_s.downcase == attribute_value.to_s.downcase }
    end
  end

  def all
    merchants
  end

  def random
    merchants.sample
  end

# returns the total revenue for that date across all merchants
  def revenue(date)
    merchants.map{|merchant| merchant.revenue(date)}.reduce(:+)
  end

  def most_revenue(number_of_results)
    top = merchants.sort_by {|merchant| merchant.revenue }.reverse
    top[0..number_of_results-1]
  end

  def most_items(number_of_results)
    top = merchants.sort_by {|merchant| merchant.total_items_sold }.reverse
    top[0..number_of_results-1]
  end

  def find_items_from(id)
    engine.find_items_from_merchant(id)
  end

  def find_invoices_from(id)
    engine.find_invoices_from_merchant(id)
  end

  def inspect
    "#<#{self.class} #{merchants.size} rows>"
  end
end
