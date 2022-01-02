# TODO: Write documentation for `Idat`
module Idat
  VERSION = "0.1.0"

  #toml = TOML.parse(File.read("/PATH/TO/FILE"))

  {% if flag?(:linux) %}
    puts "You are on Linux"
  {% elsif flag?(:darwin) %}
    puts "You are on Mac"
  {% elsif flag?(:win32) %}
    puts "You are on Windows"
  {% else %}
    puts "You are unsupported"
  {% end %}

end
