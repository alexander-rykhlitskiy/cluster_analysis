class Clusterizing::Center < Clusterizing::Vector
  attr_accessor :vectors
  def initialize(properties, vectors=[])
    @properties, @vectors = properties, vectors
  end

  def <<(vector)
    @vectors << vector
  end

  def get_area_mass_center
    if @vectors.count.zero?
      self
    else
      mean_properties = (0...@properties.count).map do |prop_index|
        prop_sum = @vectors.map { |vector| vector[prop_index] }.reduce(:+).to_i
        prop_mean = prop_sum / @vectors.count
      end
      Clusterizing::Center.new(mean_properties)
    end
  end
end
