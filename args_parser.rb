require 'optparse'

class ArgsParser
  def self.parse
    options = {}
    optparse = OptionParser.new do |opts|
      opts.banner = "Usage: [options]"

      opts.on("-i", "--image-path [String]", String, "Path to image file.") do |opt|
        options[:image_path] = opt
      end

      opts.on("-n", "--clusters-number [Integer]", Integer, "Desired number of clusters.") do |opt|
        raise(OptionParser::InvalidArgument, 'clusters number must be integer') if opt.nil?
        options[:clusters_number] = opt
      end

      opts.on("-o", "--output-file-name [String]", String, "Name of output files (charts and colored image).") do |opt|
        options[:output_file_name] = opt
      end

      opts.on("-b", "--blur-coefficient [Float]", Float, "Coefficient of gaussian blur.") do |opt|
        raise(OptionParser::InvalidArgument, 'blur coefficient must be a float number') if opt.nil?
        options[:blur_coefficient] = opt
      end

      opts.on("-l", "--black-limit-coefficient [Float]", Float, "Coefficient of limit black color.") do |opt|
        raise(OptionParser::InvalidArgument, 'blur coefficient must be a float number') if opt.nil?
        options[:black_limit_coefficient] = opt
      end

      opts.on("-a", "--annotate-shapes", "Display on image info about shapes.") do |opt|
        options[:annotate_shapes] = opt
      end

      opts.on("-d", "--debug-mode", "Require libraries for debugging.") do |opt|
        options[:debug_mode] = opt
      end
    end

    begin
      optparse.parse!
      mandatory = [:image_path, :clusters_number]
      missing = mandatory.select { |param| options[param].nil? }

      if not missing.empty?
        puts "Missing options: #{missing.join(', ')}"
        puts optparse
        exit
      end
    rescue OptionParser::InvalidOption, OptionParser::MissingArgument, OptionParser::InvalidArgument
      puts $!.to_s
      puts optparse
      exit
    end
    options
  end
end
