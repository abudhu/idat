class ValidateHandler
  def initialize(argument, file)
    @validateString = argument.as(String)
    @cf = Common.new(file)
  end

  def validate()
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
