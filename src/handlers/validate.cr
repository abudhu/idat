class ValidateHandler
  def initialize(argument, file, @dry_run = false)
    @validateString = argument.as(String)
    @cf = Common.new(file)
  end

  def validate()
    if @dry_run
      puts "[dry-run] Would validate: #{@validateString.colorize(:magenta)}"
      return true
    end
    puts "Validating... #{@validateString.colorize(:magenta)}"
    content = File.read_lines(@cf.projectLogFile)
    content = (content.last(2)).first
    @cf.idatLog("Validating: #{@validateString}")

    replacementValidate = @cf.substituteVariables(@validateString)

    #puts replacementValidate

    if replacementValidate == content
      puts "#{content} matches #{replacementValidate}\n".colorize(:green)
      @cf.idatLog("#{content} matches #{replacementValidate}")
      return true
    else
      puts "#{content} does NOT match #{replacementValidate}\n".colorize(:red)
      @cf.idatLog("#{content} does NOT match #{replacementValidate}")
      Process.exit      
    end
  end

end
