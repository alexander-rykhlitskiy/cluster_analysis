require_relative 'two_neighbor_pixels'
require_relative 'shape'
require_relative 'support'

class AreaAllocator
  def initialize(image)
    @image = image
    @pixels = []
    @view_pixels = image.view(0, 0, image.columns, image.rows)
    @n_area_counter = 0
    @areas_array = AreasArray.new
  end

  def allocate
    @image.each_pixel do |pix, x, y|
      pix.x, pix.y = x, y
      if ((pix.red + pix.green + pix.blue) / 3) < (MAX_INT / 2)
        # pix.red = pix.green = pix.blue = 0
        # pix.color_label = 0
      else
        # pix.red = pix.green = pix.blue = MAX_INT
        pix.color_label = 1
        compare_pixel_to_neighbors(pix, x, y)
      end
      pixels << pix
    end

    set_true_area_number_to_pixels
    @pixels
  end

  private

  def set_true_area_number_to_pixels
    @pixels.each do |pix|
      if !pix.area_number.nil?
        pix.area_number = @areas_array.index { |x| x.include?(pix.area_number) }
      end
    end
  end

  def compare_pixel_to_neighbors(pix, x, y)
    neighbors = TwoNeighborPixels.new(@view_pixels[y][x-1], @view_pixels[y-1][x])

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
    target_group_index = self.index { |areas_group| !(areas_group & areas).empty? }
    if target_group_index.nil?
      self << areas
    else
      self[target_group_index] = (self[target_group_index] | areas)
    end
  end
end
