class CustomerRepository
  attr_reader :engine, :customers

  def initialize(engine, customers = [])
    @engine = engine
    @customers = customers
  end


  [:id, :first_name, :last_name, :created_at, :updated_at].each do |attribute|
    define_method("find_by_#{attribute}") do |attribute_value|
      customers.find { |object| object.send(attribute).to_s.downcase == attribute_value.to_s.downcase }
    end

    define_method("find_all_by_#{attribute}") do |attribute_value|
      customers.select { |object| object.send(attribute).to_s.downcase == attribute_value.to_s.downcase }
    end
  end
  
  # [:id, :first_name, :last_name, :created_at, :updated_at].each do |attribute|
  #   define_method("find_all_by_#{attribute}") do |attribute_value|
  #     customers.select { |object| object.send(attribute).to_s.downcase == attribute_value.to_s.downcase }
  #   end
  # end

  def all
    customers
  end

  def random
    customers.sample
  end

  def find_invoices(customer_id)
    engine.find_all_invoices_by_customer_id(customer_id)
  end

  def inspect
    "#<#{self.class} #{customers.size} rows>"
  end
end
