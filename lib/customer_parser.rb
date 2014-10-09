require 'csv'
require_relative 'customer'

class CustomerParser
  def initialize(repository, filepath)
    customer_data = CSV.readlines filepath, headers: true, header_converters: :symbol
    create_customer_objects(repository, customer_data)
  end

  def create_customer_objects(repository, customer_data)
    customer_data.collect do |customer_data|
      customer_data[:id] = customer_data[:id].to_i
      Customer.new(repository, customer_data)
    end
  end
end
