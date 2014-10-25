MAX_INT = 256 * 256 - 1

class Magick::Image::View
  def each(&block)
    for x in (0...self.height) do
      for y in (0...self.width) do
        yield(self[x][y], x, y)
      end
    end
  end

  def map(&block)
    result = []
    each { |pix| result << yield(pix) }
    result
  end

  def group_by(&block)
    result = {}
    each do |pix|
      key = yield(pix)
      result[key] ||= []
      result[key] << pix
    end
    result
  end

end

# class Array
#   def group_by_any_included
#     self.each_with_object([]) do |array_element, memo|
#       memo_eq_to_this_two_areas = memo.find { |x| !(x & array_element).empty? }

#       if memo_eq_to_this_two_areas.nil?
#         memo << array_element
#       else
#         memo.delete(memo_eq_to_this_two_areas)
#         memo << (memo_eq_to_this_two_areas | array_element)
#       end
#     end
#   end

#   def group_by_any_included!
#     self_dup = self.dup
#     self.clear
#     self_dup.group_by_any_included.each { |x| self << x }
#   end
# end

class Magick::Pixel
  attr_accessor :color_label, :area_number
end
