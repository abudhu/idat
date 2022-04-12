class RunHandler
  def initialize(argument, file)
    @runCmd = argument.as(String)
    @cf = Common.new(file)
  end

  def execProcess
    puts @runCmd
    @cf.idatLog("Running #{@runCmd}")
    cmdExecution = @cf.processRun(@runCmd)
    puts cmdExecution
    @cf.idatLog(cmdExecution)
  end

end
