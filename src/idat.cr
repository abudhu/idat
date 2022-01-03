# TODO: Write documentation for `Idat`
require "toml"
require "colorize"

SUB_ARRAY = [] of String

def validateToml(toml_file toml)
  toml = toml.as(Hash)
  toml.has_key?("projectInfo")
  toml.has_key?("projectSettings")
end

def getSystem()
  {% if flag?(:linux) %}
    os = "Linux"
  {% elsif flag?(:darwin) %}
    os = "Mac"
  {% elsif flag?(:win32) %}
    os = "Windows"
  {% else %}
    os = "Unsupported"
  {% end %}
end

def validateSystem(*, tomlSystem)
  systemOS = getSystem
  if tomlSystem.includes?(systemOS)
   puts "Validating System...#{"Success".colorize(:green)}"
  else
    puts "Validating System...#{"Fail".colorize(:red)}"
    exit
  end
end

def collapse_hash(sub_hash)
  sub_hash.each do | k, v |
    SUB_ARRAY.push(k)
    unless v.is_a?(Hash)
      #puts "No Sub Hash, value is: #{v}"
      SUB_ARRAY.push(v.to_s)
      #puts SUB_ARRAY
    else
      collapse_hash(v)
    end
  end
  #puts "Final Sub_Array is: #{SUB_ARRAY}"
end

class Handlers

  macro dispatch(type, params)
    case {{ type.id }}
    {% for method in @type.methods %}
      {% if method.name =~ /^handle_/ %}
    when "{{ method.name.gsub(/^handle_/, "") }}" then {{ method.name.id }}({{ params.id }})
      {% end %}
    {% end %}
    else
      raise NotImplementedError.new("handle_#{ {{ type.id }} }")
    end
  end
  

  def handle_run()
  end 

  def handle_install()
  end

  def handle_validate()
  end

  

  
end


def handle_run(params)
  puts "Running... #{params.colorize(:cyan)}"
end 

def handle_install(params)
  puts "Installing... #{params.colorize(:green)}"
end 

def handle_validate(params)
  puts "Validating... #{params.colorize(:magenta)}"
end 



module Idat
  VERSION = "0.1.0"


  toml = TOML.parse(File.read("solutions/ruby_install.toml"))

   
  #toml.each do | k,v | 
  #  SUB_ARRAY.push(k)
  #  if v.is_a?(Hash)
  #    collapse_hash v
  #  end
  #end
  #puts SUB_ARRAY
  
  
  #puts toml.dig("projectSteps")
  
  #puts SUB_ARRAY

  #puts empty_array

  #validateToml toml_file: toml
  
  #puts toml.keys

  startTime = Time.local

  projectInfo = toml["projectInfo"].as(Hash)
  projectSettings = toml["projectSettings"].as(Hash)

  puts "Starting #{(projectInfo["name"]).colorize(:green)} at #{startTime}"

  validateSystem(tomlSystem: projectSettings["system"].as(Array))

  projectSteps = toml["projectSteps"].as(Hash)

  #Handlers.dispatch("\"amit\"", "\"do_stuff\"")
  projectSteps.each do | k, v |
    puts "Executing Step: #{k.colorize.fore(:yellow).mode(:bold)}"
    v.as(Hash).each do | k2, v2 |
      
      Handlers.dispatch(k2,v2)      
    end
    puts "\n"
  end

end


