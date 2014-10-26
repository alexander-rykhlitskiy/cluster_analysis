module Paintable
  attr_reader :pixels

  def paintings
    [ -> { paint_green }, -> { paint_red }, -> { paint_blue },
      -> { paint_purple }, -> { paint_yellow }, -> { paint_ocean }]
  end

  def paint_ocean
    paint(red: 0, green: MAX_INT, blue: MAX_INT)
  end

  def paint_blue
    paint(red: 0, green: 0, blue: MAX_INT)
  end

  def paint_green
    paint(red: 0, green: MAX_INT, blue: 0)
  end

  def paint_red
    paint(red: MAX_INT, green: 0, blue: 0)
  end

  def paint_yellow
    paint(red: MAX_INT, green: MAX_INT, blue: 0)
  end

  def paint_purple
    paint(red: MAX_INT, green: 0, blue: MAX_INT)
  end

  def paint(colors)
    @pixels.each do |pix|
      pix.red = colors[:red]
      pix.green = colors[:green]
      pix.blue = colors[:blue]
    end
  end
end
