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
        puts "Running... #{cmd.colorize.mode(:bold)}"
        @cf.idatLog("Running Command: #{cmd}")
        cmdExecution = @cf.processRun(cmd)
        puts cmdExecution
      end
    else
      puts "Running... #{replacementCmd.colorize.mode(:bold)}"
      @cf.idatLog("Running Command: #{replacementCmd}")
      cmdExecution = @cf.processRun(replacementCmd)
      puts cmdExecution
    end
    
  end
end
