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

    # So this thing is neat...
    # We open the Project Steps, which look like {key => value} ex: {run => my thing}, where this is a tuple under the header [step]
    # So for each [Step] (key) the Value is {run => my thing}
    # So we step inside {run => thing}
    # Now Run is Key and Thing is Value
    # then we split the entire Value up on the spaces
    # So now its a big array of segemented words
    # So we scan each element in the array for ${}
    # Next we strip off all the ${} 
    # then we look at our Project Variables, and find one that matches and get its value
    # Then we stick that value in the position it was discovered in the array
    # then we rejoin the entire array
    # Then we go look at the original Key Pairs: [YourStep]{run = > something}  And since that is Key : Value, we say
    # select YourStepas the Hash, then select the key (run) the replace it with the correct line. 
    #def substituteVariables
    #  @@projectSteps.each do | k, v |
    #    v.as(Hash).each do | k2, v2 |
    #      sub = v2.to_s.scan(/\${(.*)}/)
    #      if !sub.empty?
    #        lineReplacement = v2
    #        lineReplacement = lineReplacement.to_s.split(" ")
    #        lineReplacement.each_with_index do | element, position |
    #          isVar = element.scan(/\${(.*)}/)
    #          if !isVar.empty?
    #            cleanVar = isVar[0][0].to_s.gsub("{", "").gsub("}","").gsub("$","")
    #            replacementValue = (@@projectInformation.as(Hash)["projectVariables"].as(Hash).values_at(cleanVar)[0]).to_s
    #            lineReplacement[position] = replacementValue
    #          end
    #        end
    #        lineReplacement = lineReplacement.join(" ")
    #        @@projectSteps[k].as(Hash)[k2] = lineReplacement
    #      end
    #    end
    #  end
      #puts @@projectSteps

    #end

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
    
    private def handle_install(params, @projectVariables)
      puts "I got here at least?"
      instlFunc = InstallFunctions.new(params)
    end 
    
    private def handle_validate(params)
      valdFunc = ValidateFunctions.new(params)
    end 

  end
end
