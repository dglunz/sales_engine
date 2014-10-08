require 'csv'
require_relative 'merchant'

class MerchantParser
  attr_reader :merchants
  def initialize(repository, filepath)
    merchant_data = CSV.readlines filepath, headers: true, header_converters: :symbol
    create_merchant_objects(repository, merchant_data)
  end

  def create_merchant_objects(repository, merchant_data)
    @merchants = merchant_data.collect do |merchant_data|
      merchant_data[:id] = merchant_data[:id]
      merchant_data[:name] = merchant_data[:name]
      merchant_data[:created_at] = merchant_data[:created_at].to_s.downcase
      merchant_data[:updated_at] = merchant_data[:updated_at].to_s.downcase
      Merchant.new(repository, merchant_data)
    end
  end
end
