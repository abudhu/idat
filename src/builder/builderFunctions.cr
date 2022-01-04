require "toml"

module Idat
  class BuilderFunctions

    def initialize(toml_file)
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

    # You need to do any subsitutions of variables, thus creating a proper hash
    def substituteVariables
    end

    def executeSolution
      puts "Executing Solution: #{@toml_file["projectInfo"].as(Hash)["name"].colorize.mode(:bold)}!\n\n"
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
