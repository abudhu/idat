require "toml"

module Idat
  class ValidatorFunctions

    def initialize(file)
      @toml_file = TOML.parse(File.read(file))
      puts "\n#{"Starting Validation...".colorize.mode(:bold)}\n\n"
    end

    def validateToml
      unless @toml_file.has_key?("projectInfo") && @toml_file.has_key?("projectSettings") && @toml_file.has_key?("projectVariables")
        raise "TOML file missing one of the following Project Keys: [projectInfo], [projectDescriotion], or [projectVariables]\n"
      else
        puts "Validating TOML File...#{"Success".colorize(:green)}\n"
      end
    end

    def validateSystem
      systemOS = getSystem
      validateProjectSettings = @toml_file["projectSettings"].as(Hash)
      unless validateProjectSettings.has_key?("system")
        puts "Project Settings missing 'System' Key : Value pair.\n"
      else
        if validateProjectSettings["system"].as(Array).includes?(systemOS)
          puts "Validating System...#{"Success".colorize(:green)}\n\n"
        else
          puts "Validating System...#{"Fail".colorize(:red)}\n"
        end
      end 
    end

    private def getSystem()
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

  end
end

