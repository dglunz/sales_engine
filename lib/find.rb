module Find

  def self.find_by_generator(collection)
    if collection.first
      collection.first.attributes.each do |attribute|
        define_method("find_by_#{attribute}") do |attribute_value|
          collection.find { |object| object.send(attribute) == attribute_value.downcase }
        end
      end
    end
  end

  def self.find_all_by_generator(collection)
    if collection.first
      collection.first.attributes.each do |attribute|
        define_method("find_all_by_#{attribute}") do |attribute_value|
          collection.select { |object| object.send(attribute) == attribute_value.downcase }
        end
      end
    end
  end


end