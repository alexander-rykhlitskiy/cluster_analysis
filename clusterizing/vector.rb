class Vector
  extend Forwardable
  attr_reader :properties
  def_delegators :@properties, :[]

  def initialize(properties)
    @properties = properties
  end

  def distance_to(vector)
    raise 'wrong vector arity' if vector.properties.count != properties.count

    properties.each.with_index.inject(0) do |memo, (property, index)|
      memo + ((property - vector.properties[index]) ** 2)
    end
  end

  def distance_from_start
    @properties.map { |prop| prop ** 2 }.reduce(:+)
  end

  def to_center
    Center.new(properties)
  end

end
