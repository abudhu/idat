class BuildFunctions

  @file : String
  @dry_run : Bool

  def initialize(file, dry_run = false)
    @file = file
    @dry_run = dry_run
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
    if @dry_run
      puts "\n#{"[DRY-RUN]".colorize(:cyan)} Solution: #{@cf.projectInfo["name"].colorize.mode(:bold)}\n\n"
    else
      @cf.idatLog(Time.utc)
      @cf.idatLog("Executing Solution: #{@cf.projectInfo["name"]}")
      puts "Executing Solution: #{@cf.projectInfo["name"].colorize.mode(:bold)}!\n\n"
    end
    
    @cf.projectSteps.each do | step, action |
      action.as(Hash).each do | handler, argument |
        dispatch(handler, argument)
      end
    end

  end

  private def handle_run(argument)
    runHandler = RunHandler.new(argument, @file, @dry_run)
    runHandler.execProcess
  end 
  
  private def handle_install(argument)
    installHandler = InstallHandler.new(argument, @file, @dry_run)
    installHandler.install
  end 
  
  private def handle_validate(argument)
    validateHandler = ValidateHandler.new(argument, @file, @dry_run)
    validateHandler.validate
  end 

  private def handle_append(argument)
    appendHandler = AppendHandler.new(argument, @file, @dry_run)
    appendHandler.append
  end 

  private def handle_bash(argument)
    bashHandler = BashHandler.new(argument, @file, @dry_run)
    bashHandler.execProcess
  end 



end



