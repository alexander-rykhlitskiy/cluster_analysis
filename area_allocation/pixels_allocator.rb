class PixelsAllocator
  GRAY_LIMIT_COEFFICIENT = 0.6

  def initialize(bitmap)
    @bitmap = bitmap
    @n_area_counter = 0
    @areas_array = AreasArray.new
  end

  def allocate(black_limit_coefficient)
    compare_coefficient = MAX_INT * (black_limit_coefficient || GRAY_LIMIT_COEFFICIENT)
    @bitmap.each_with_xy do |pix, x, y|
      pix.x, pix.y = x, y
      if ((pix.red + pix.green + pix.blue) / 3) < compare_coefficient
        # pix.red = pix.green = pix.blue = 0
        # pix.color_label = 0
      else
        # pix.red = pix.green = pix.blue = MAX_INT
        pix.color_label = 1
        compare_pixel_to_neighbors(pix, x, y)
      end
    end

    set_true_area_number_to_pixels
    @bitmap
  end

  private

  def set_true_area_number_to_pixels
    @bitmap.each_with_xy do |pix|
      if pix.area_number
        pix.area_number = @areas_array.index { |x| x.include?(pix.area_number) }
      end
    end
  end

  def compare_pixel_to_neighbors(pix, x, y)
    neighbors = TwoNeighborPixels.new(@bitmap[x-1][y], @bitmap[x][y-1])

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
    target_group_indexes = self.each_index.select do |areas_group_index|
      areas_group = self[areas_group_index]
      common_elements = (areas_group & areas)
      !common_elements.empty?
    end
    if target_group_indexes.empty?
      self << areas
    else
      if target_group_indexes.count == 1
        self[target_group_indexes.first] = (self[target_group_indexes.first] | areas)
      else
        self[target_group_indexes.first] = (self[target_group_indexes.first] | self[target_group_indexes.last])
        self.delete_at(target_group_indexes.last)
      end
    end
  end
end
