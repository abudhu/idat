# TODO: Write documentation for `Idat`
require "toml"
require "colorize"

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
  end
end

module Idat
  VERSION = "0.1.0"


  toml = TOML.parse(File.read("solutions/ruby_install.toml"))

  validateToml toml_file: toml
  
  #puts toml.keys

  startTime = Time.local

  projectInfo = toml["projectInfo"].as(Hash)
  projectSettings = toml["projectSettings"].as(Hash)

  puts "Starting #{(projectInfo["name"]).colorize(:green)} at #{startTime}"

  validateSystem(tomlSystem: projectSettings["system"].as(Array))

  projectSteps = toml["projectSteps"].as(Hash)

  projectSteps.each do | k, v |
    puts "Running step #{k.colorize.fore(:yellow).mode(:bold)}"
    puts "Executing #{v.as(Hash)["run"].colorize(:cyan)} command"
  end

  end
