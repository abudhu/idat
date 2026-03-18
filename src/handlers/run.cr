class RunHandler
  def initialize(argument, file, @dry_run = false)
    @runCmd = argument.as(String)
    @cf = Common.new(file)
  end

  def execProcess
    @cf.idatLog("Running Command: #{@runCmd}")
    replacementCmd = @cf.substituteVariables(@runCmd)
    if replacementCmd.is_a?(Array)
      replacementCmd.each do | cmd |
        if @dry_run
          puts "[dry-run] Would run: #{cmd.colorize.mode(:bold)}"
        else
          puts "Running... #{cmd.colorize.mode(:bold)}"
          @cf.idatLog("Running Command: #{cmd}")
          cmdExecution = @cf.processRun(cmd)
          puts cmdExecution
        end
      end
    else
      if @dry_run
        puts "[dry-run] Would run: #{replacementCmd.colorize.mode(:bold)}"
      else
        puts "Running... #{replacementCmd.colorize.mode(:bold)}"
        @cf.idatLog("Running Command: #{replacementCmd}")
        cmdExecution = @cf.processRun(replacementCmd)
        puts cmdExecution
      end
    end
    
  end
end
