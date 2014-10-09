require 'csv'
require_relative 'item'

class ItemParser
  attr_reader :items

  def initialize(repository, filepath)
    item_data = CSV.readlines filepath, headers: true, header_converters: :symbol
    create_item_objects(repository, item_data)
  end

  def create_item_objects(repository, item_data)
    @items = item_data.collect do |item_data|
      Item.new(repository, item_data)
    end
  end
end
