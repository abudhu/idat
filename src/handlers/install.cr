class InstallHandler
  @appList : Array(TOML::Type) | String
  def initialize(argument, file)
    if argument.is_a?(Array)
      @appList = argument.as(Array)
    else
      @appList = argument.as(String)
    end
    @cf = Common.new(file)
  end

  def install
    installer = getInstallerType 
    @cf.idatLog("Installing: #{@appList} using #{installer}")
    if @appList.is_a?(Array)
      @appList.as(Array).each do | app |
        cmdExecution = @cf.processRun("#{installer} #{app}")
        puts cmdExecution
      end
    else
      replacementAppList = @cf.substituteVariables(@appList.as(String))
      if replacementAppList.is_a?(Array)
        replacementAppList.each do | app |
          cmdExecution = @cf.processRun("#{installer} #{app}")
          puts cmdExecution
        end
      else
        cmdExecution = @cf.processRun("#{installer} #{replacementAppList}")
        puts cmdExecution
      end
    end
    
  end

  def getInstallerType

    systemOS = @cf.getSystem

    case systemOS 
    when "Linux"
      getInstaller = getLinuxDistro
    else
      puts "Not Ready Yet"
    end
  
  end


end

# @cf.idatLog("Running Command: #{@runCmd}")
# replacementCmd = @cf.substituteVariables(@runCmd)
# if replacementCmd.is_a?(Array)
#   replacementCmd.each do | cmd |
#     puts "Running... #{cmd.colorize.mode(:bold)}"
#     @cf.idatLog("Running Command: #{cmd}")
#     cmdExecution = @cf.processRun(cmd)
#     puts cmdExecution
#   end
# else
#   puts "Running... #{replacementCmd.colorize.mode(:bold)}"
#   @cf.idatLog("Running Command: #{replacementCmd}")
#   cmdExecution = @cf.processRun(replacementCmd)
#   puts cmdExecution
# end


private def getLinuxDistro()
  io = IO::Memory.new
  Process.run("grep '^ID_LIKE' /etc/os-release", shell: true, output: io)
  linuxDistro = io.to_s.lchop("ID_LIKE=").chomp
  
  #puts linuxDistro

  case linuxDistro
  when "debian"
    installCmd = "sudo apt-get install"
  else
    installCmd = "unknown"
  end

end


# @params : Array(TOML::Type) | String
#     def installApp()
#       cf = CommonFunctions.new()
      
#       if @params.is_a?(Array)
#         @params.as(Array).each do | app |
#           puts "Installing... #{app.colorize(:green)}"
#           cf.processRun("#{@sysInstaller} #{app} -y")
#         end
#       else
#         newCmd = cf.substituteVariables(@params.as(String), @projectVariables)
#         if newCmd.is_a?(Array)
#           newCmd.each do | cmd |
#             puts "Installing... #{cmd.colorize(:green)}"
#             cf.processRun("#{@sysInstaller} #{cmd} -y")
#           end
#         else
#           puts "Installing... #{newCmd.colorize(:green)}"
#           cf.processRun("#{@sysInstaller} #{newCmd} -y")
#         end
#       end
#     end
#   end
# end
