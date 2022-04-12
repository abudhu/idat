class BuildFunctions

  @file : String

  def initialize(file)
    # if you parse the file
    # and get the common top info
    # you can then send it to common
    # and then you can do common.name / common.file / common.log??
    @file = file
    @cf = Common.new(file)
    #puts @cf.projectInfo
    #puts @cf.projectSettings
    #puts @cf.projectVariables
    #puts @cf.projectSteps
    #puts @cf.projectLogFile
    #@cf.idatLog("And more new info in a different run")
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
    instlFunc = InstallHandler.new()
    #instlFunc.installApp
  end 
  
  private def handle_validate(argument)
    valdFunc = ValidateHandler.new()
  end 



end



