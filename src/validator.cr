module Idat
  class Validator

    def initialize()
    end

    def validateToml(toml_file)
      unless toml_file.has_key?("projectInfo") && toml_file.has_key?("projectSettings") && toml_file.has_key?("projectVariables")
        raise "TOML file missing one of the following Project Keys: [projectInfo], [projectDescriotion], or [projectVariables]"
      else
        puts "Toml File Validation...Success"
      end
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
