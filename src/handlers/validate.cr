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

    if @validateString == content
      puts "#{@validateString} matches #{content}".colorize(:green)
      @cf.idatLog("#{@validateString} matches #{content}")
      return true
    else
      puts "#{@validateString} does NOT match #{content}".colorize(:red)
      @cf.idatLog("#{@validateString} does NOT match #{content}")
      Process.exit      
    end
  end

end
