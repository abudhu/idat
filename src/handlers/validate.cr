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
      puts "#{content} matches #{@validateString}\n".colorize(:green)
      @cf.idatLog("#{content} matches #{@validateString}")
      return true
    else
      puts "#{content} does NOT match #{@validateString}\n".colorize(:red)
      @cf.idatLog("#{content} does NOT match #{@validateString}")
      Process.exit      
    end
  end

end
