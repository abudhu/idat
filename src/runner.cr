require "toml"
require "colorize"

module Idat
  class Runner
    
		def initialize(toml_file : String)
			@toml_file = TOML.parse(File.read(toml_file))
    end

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

    def execute
      validate_solution
      run_steps
    end

    private def validate_solution
      unless @toml_file.has_key?("projectInfo") && @toml_file.has_key?("projectSettings")
        raise "Missing Required keys"
      else
        puts "Toml File Validation...Success"
      end
    end

    private def run_steps
      #projectInformation = @toml_file.select({"projectInfo","projectSettings","projectVariables"})

      projectSteps = @toml_file.reject("projectInfo","projectSettings","projectVariables")

      projectSteps.each do | k, v |
        puts "Executing Step: #{k.colorize.fore(:yellow).mode(:bold)}"
        v.as(Hash).each do | k2, v2 |
          dispatch(k2,v2)      
        end
        puts "\n"
      end
    end

    private def handle_run(params)
      puts "Running... #{params.colorize(:cyan)}"
    end 
    
    private def handle_install(params)
      puts "Installing... #{params.colorize(:green)}"
    end 
    
    private def handle_validate(params)
      puts "Validating... #{params.colorize(:magenta)}"
    end 

  end
end
