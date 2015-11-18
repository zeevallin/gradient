module Gradient
  class GRD

    SHIFT_BUFFER = "                                    "
    COLOR_TERMS = %w(Cyn Mgnt Ylw Blck Rd Grn Bl H Strt Brgh)
    PARSE_METHODS = {
      "patt" => :parse_patt,
      "desc" => :parse_desc,
      "VlLs" => :parse_vlls,
      "TEXT" => :parse_text,
      "Objc" => :parse_objc,
      "UntF" => :parse_untf,
      "bool" => :parse_bool,
      "long" => :parse_long,
      "doub" => :parse_doub,
      "enum" => :parse_enum,
      "tdta" => :parse_tdta,
    }

    attr_reader :maps

    class << self

      def parse(file)
        new(file).maps
      end

    end

    def initialize(file)
      @maps = {}

      @gradient_names = []
      @color_gradients = []

      @current_object_name = ""
      @current_color_gradient = []
      @current_color = {}

      @shift = 0

      File.open(file, "r") do |file|
        parse while (@buffer = file.gets)
      end
    end

    private def parse
      @offset = 28
      parse_entry while @offset < @buffer.length
      flush_current_gradient

      color_gradients = @color_gradients.map do |gradient|
        clean_color_gradient(gradient).map do |color_step|
          Gradient::ColorPoint.new(*color_step)
        end
      end

      gradients = color_gradients.map do |color_points|
        Gradient::Map.new(*color_points)
      end

      @maps = Hash[ @gradient_names.zip(gradients) ]
    end

    private def clean_gradient(steps)
      locations = steps.map { |g| g["Lctn"] }
      min_location = locations.min
      max_location = locations.max
      locations = locations.map do |location|
        ((location - min_location) * (1.0 / (max_location - min_location))).round(3)
      end

    private def clean_color_gradient(steps)
      locations = clean_gradient(steps)
      colors = steps.map do |step|
        convert_to_color(step)
      end
      locations.zip(colors)
    end

    end

    private def convert_to_color(color_data)
      case format = color_data["palette"]
      when "CMYC" then Color::CMYK.from_percent(*color_data.values_at("Cyn", "Mgnt", "Ylw", "Blck").map(&:round))
      when "RGBC" then Color::RGB.new(*color_data.values_at("Rd", "Grn", "Bl").map(&:round))
      when "HSBC"
        h = color_data.fetch("H")
        s = color_data.fetch("Strt") / 100.0
        l = color_data.fetch("Brgh") / 100.0
        Color::HSL.from_fraction(h, s, l)
      else
        raise NotImplementedError.new("The color #{format} is not supported")
      end
    end

    # Unpack 8 bytes IEEE 754 value to floating point number
    private def current_float_slice
      @buffer.slice(@offset, 8).unpack("G").first
    end

    private def current_slice_length
      current_slice.unpack("L>").first
    end

    private def current_slice(length=4)
      @buffer.slice(@offset, length)
    end

    private def continue!(steps=4)
      @offset += steps
    end

    private def upshift!
      @shift += 4
    end

    private def downshift!
      @shift -= 4
    end

    private def log(name, type, *args)
      puts "#{Array.new(@shift, " ").join}#{name}(#{type}) #{ Array(args).join(", ") }" if ENV["ENABLE_LOG"]
    end

    private def send_parse_method(type, name)
      if parse_method = PARSE_METHODS.fetch(type, nil)
        send(parse_method, name)
      else
        parse_unknown(name)
      end
    end

    private def parse_entry
      length = current_slice_length
      length = 4 if length.zero?
      continue!

      name = current_slice
      continue!(length)

      type = current_slice
      continue!

      send_parse_method(type, name)
    end

    private def flush_current_gradient
      flush_current_color
      @color_gradients << @current_color_gradient if @current_color_gradient.any?
      @current_color_gradient = []
    end

    private def flush_current_color
      @current_color_gradient << @current_color if @current_color.any?
      @current_color = {}
    end

    private def parse_patt(name)
      # TODO: Figure out exactly what this is and implement it.
      log(name, "patt")
    end

    private def parse_desc(name)
      size = current_slice_length
      log(name, "desc", size)
      continue!(26)
    end

    private def parse_vlls(name)
      size = current_slice_length
      continue!
      log(name, "vlls", size)
      upshift!

      size.times do
        type = current_slice
        continue!
        send_parse_method(type, name)
      end

      downshift!
    end

    private def parse_text(name)
      size = current_slice_length
      characters = []

      (0..size).each_with_index do |string, idx|
        a = @offset + 4 + idx * 2 + 1
        b = @offset + 4 + idx * 2 + 2
        characters << @buffer[a...b]
      end

      text = characters.join

      log(name, "text", size, text)

      if @current_object_name == "Grad" && name.strip == "Nm"
        @gradient_names << text.strip
      end

      continue!(4 + size * 2)
    end

    private def parse_objc(name)
      object_name_length = current_slice_length
      continue!

      object_name = current_slice(object_name_length * 2)
      continue!(object_name_length * 2)

      object_type_length = current_slice_length
      object_type_length = 4 if object_type_length.zero?
      continue!

      object_type = current_slice(object_type_length)
      continue!(object_type_length)

      object_size = current_slice_length
      continue!

      log(name, "objc", object_size, object_type, object_name)

      @current_object_name = name.strip
      case @current_object_name
      when "Grad"
        flush_current_gradient
      when "Clr"
        flush_current_color
        @current_color = { "palette" => object_type.strip }
      end

      upshift!
      object_size.times { parse_entry }
      downshift!
    end

    private def parse_untf(name)
      type = current_slice
      value = @buffer.slice(@offset + 4, 8).unpack("G").first
      log(name, "untf", type, value)

      if @current_object_name == "Clr" && COLOR_TERMS.include?(name.strip)
        @current_color[name.strip] = value
      end

      continue!(12)
    end

    private def parse_bool(name)
      value = @buffer.slice(@offset, 1).ord
      log(name, "bool", value)
      continue!(1)
    end

    private def parse_long(name)
      size = current_slice_length
      log(name, "long", size)

      if @current_object_name == "Clr" && name == "Lctn"
        @current_color[name.strip] = size
      end

      continue!
    end

    private def parse_doub(name)
      value = current_float_slice
      log(name, "doub", value)

      if @current_object_name == "Clr" && COLOR_TERMS.include?(name.strip)
        @current_color[name.strip] = value
      end

      continue!(8)
    end

    private def parse_enum(name)
      size_a = current_slice_length
      continue!
      size_a = 4 if size_a.zero?
      name_a = current_slice(size_a)
      continue!(size_a)

      size_b = current_slice_length
      continue!
      size_b = 4 if size_b.zero?
      name_b = current_slice(size_b)
      continue!(size_b)

      log(name, "enum", name_a, name_b)
    end

    private def parse_tdta(name)
      log(name, "tdta")
      parse_unknown(name)
    end

    private def parse_unknown(name)
      name = @buffer.slice(@offset + 8, 4)
      log(name, "unknown", "Failed with simple case")

      hex = []
      ascii = []

      (0...15).times do |i|
        begin
          ord = @buffer[@offset + i].ord
          hex << "%02x" % ord
          ascii << (ord < 32 || 126 < ord) ? "." : ord
        rescue
          log(name, "unknown", "Something failed")
        end
      end

      fail [hex.join(" "), ascii.join].join("\n")
    end

  end
end


