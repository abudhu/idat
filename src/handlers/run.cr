class RunHandler
  def initialize(argument, file)
    @runCmd = argument.as(String)
    @cf = Common.new(file)
  end

  def execProcess
    puts "Running... #{@runCmd.colorize.mode(:bold)}"
    @cf.idatLog("Running Command: #{@runCmd}")
    replacementCmd = @cf.substituteVariables(@runCmd)
    if replacementCmd.is_a?(Array)
      replacementCmd.each do | cmd |
        cmdExecution = @cf.processRun(cmd)
        puts cmdExecution
      end
    else
      cmdExecution = @cf.processRun(replacementCmd)
      puts cmdExecution
    end
    
  end
end
