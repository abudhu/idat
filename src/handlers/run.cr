class RunHandler
  def initialize(argument, file)
    @runCmd = argument.as(String)
    @cf = Common.new(file)
  end

  def execProcess
    @cf.idatLog("Running Command: #{@runCmd}")
    replacementCmd = @cf.substituteVariables(@runCmd)
    if replacementCmd.is_a?(Array)
      replacementCmd.each do | cmd |
        @cf.idatLog("Running Command: #{cmd}")
        puts "Running... #{cmd.colorize.mode(:bold)}"
        cmdExecution = @cf.processRun(cmd)
        puts cmdExecution
      end
    else
      cmdExecution = @cf.processRun(replacementCmd)
      @cf.idatLog("Running Command: #{replacementCmd}")
      puts "Running... #{replacementCmd.colorize.mode(:bold)}"
      puts cmdExecution
    end
    
  end
end
