class AreaAllocator
  def initialize(pixels)
    @pixels = pixels
    @n_area_counter = 0
    @areas_array = AreasArray.new
  end

  def allocate
    @pixels.each do |pix, x, y|
      if ((pix.red + pix.green + pix.blue) / 3) < (MAX_INT / 2)
        pix.red = pix.green = pix.blue = 0
        pix.color_label = 0
      else
        pix.red = pix.green = pix.blue = MAX_INT
        pix.color_label = 1
        compare_pixel_to_neighbors(pix, x, y)
      end
    end
    # @areas_array.group_by_any_included!

    @pixels.each do |pix|
      if !pix.area_number.nil?
        pix.area_number = @areas_array.index { |x| x.include?(pix.area_number) }
      end
    end
    @pixels
  end

  private

  def compare_pixel_to_neighbors(pix, x, y)
    neighbors = TwoNeighborPixels.new(@pixels[x-1][y], @pixels[x][y-1])

    if neighbors.no_one_in_area?
      @n_area_counter += 1
      pix.area_number = @n_area_counter
    elsif neighbors.only_one_in_area?
      pix.area_number = neighbors.area_number_of_one
    elsif neighbors.belongs_to_one_area?
      pix.area_number = neighbors.area_number_of_one
    elsif neighbors.belongs_to_different_areas?
      pix.area_number = neighbors.area_number_of_one
      @areas_array.add_areas(neighbors.areas_numbers)
    end
  end
end

class AreasArray < Array
  def add_areas(areas)
    target_group = self.find { |areas_group| !(areas_group & areas).empty? }

    if target_group.nil?
      self << areas
    else
      self.delete(target_group)
      self << (target_group | areas)
    end
  end
end

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
