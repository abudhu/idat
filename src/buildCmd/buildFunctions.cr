class BuildFunctions

  @file : String

  def initialize(file)
    @file = file
    @cf = Common.new(file)
  end

  macro dispatch(type, argument)
    case {{ type.id }}
    {% for method in @type.methods %}
      {% if method.name =~ /^handle_/ %}
    when "{{ method.name.gsub(/^handle_/, "") }}" then {{ method.name.id }}({{ argument.id }})
      {% end %}
    {% end %}
    else
      raise NotImplementedError.new("handle_#{ {{ type.id }} }")
    end
  end

  def executeSolution
    @cf.idatLog(Time.utc)
    @cf.idatLog("Executing Solution: #{@cf.projectInfo["name"]}")
    puts "Executing Solution: #{@cf.projectInfo["name"].colorize.mode(:bold)}!\n\n"
    
    @cf.projectSteps.each do | step, action |
      action.as(Hash).each do | handler, argument |
        dispatch(handler, argument)
      end
    end

  end

  private def handle_run(argument)
    runHandler = RunHandler.new(argument, @file)
    runHandler.execProcess
  end 
  
  private def handle_install(argument)
    installHandler = InstallHandler.new(argument, @file)
    installHandler.install
  end 
  
  private def handle_validate(argument)
    validateHandler = ValidateHandler.new(argument, @file)
    validateHandler.validate
  end 

  private def handle_append(argument)
    appendHandler = AppendHandler.new(argument, @file)
    appendHandler.append
  end 



end



