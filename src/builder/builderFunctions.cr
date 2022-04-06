require "toml"

module Idat
  class BuilderFunctions

    @@projectInformation = Hash(String, TOML::Type).new
    @@projectSteps = Hash(String, TOML::Type).new
    @projectVariables = Hash(String, TOML::Type).new

    def initialize(toml_file)
      @toml_file = TOML.parse(File.read(toml_file))
      @@projectInformation = @toml_file.select("projectInfo","projectSettings","projectVariables")
      
      @projectVariables = @toml_file.select("projectVariables")
      
      @@projectSteps = @toml_file.reject("projectInfo","projectSettings","projectVariables")

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

    def executeSolution
      puts "Executing Solution: #{@toml_file["projectInfo"].as(Hash)["name"].colorize.mode(:bold)}!\n\n"
      @@projectSteps = @toml_file.reject("projectInfo","projectSettings","projectVariables")
      @@projectSteps.each do | k, v |
        puts "Executing Step: #{k.colorize.fore(:yellow).mode(:bold)}"
        v.as(Hash).each do | k2, v2 |
          dispatch(k2,v2)      
        end
        puts "\n"
      end
    end

    private def handle_run(params)
      runFunc = RunFunctions.new(params, @projectVariables)
      runFunc.execProcess
    end 
    
    private def handle_install(params)
      instlFunc = InstallFunctions.new(params, @projectVariables)
      instlFunc.installApp
    end 
    
    private def handle_validate(params)
      valdFunc = ValidateFunctions.new(params)
    end 

  end
end
