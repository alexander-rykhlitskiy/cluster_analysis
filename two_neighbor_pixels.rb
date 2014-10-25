class TwoNeighborPixels
  def initialize(left_neighbor, top_neighbor)
    @left_neighbor, @top_neighbor = left_neighbor, top_neighbor
  end

  def areas_numbers
    [@left_neighbor.area_number, @top_neighbor.area_number]
  end

  def no_one_in_area?
    @left_neighbor.area_number.nil? && @top_neighbor.area_number.nil?
  end

  def only_one_in_area?
    @left_neighbor.area_number.nil? != @top_neighbor.area_number.nil?
  end

  def belongs_to_one_area?
    !no_one_in_area? && (@left_neighbor.area_number == @top_neighbor.area_number)
  end

  def belongs_to_different_areas?
    !no_one_in_area? && !only_one_in_area? && (@left_neighbor.area_number != @top_neighbor.area_number)
  end

  def area_number_of_one
    @left_neighbor.area_number || @top_neighbor.area_number
  end
end
