require "toml"
require "./common.cr"

module Idat
  class InstallFunctions
    def initialize(params, projectVariables)
      @projectVariables = Hash(String, TOML::Type).new
      # This needs to figure out if you use Apt, Powershell, Choco, 
      # Then needs to figure out if you gave it an array
      # Or if its a single app
      # Or if the single link got subsituted and contains and array
      #puts params.is_a?(Array)
      #puts params.is_a?(String)
      @params = params.as(String)
      @projectVariables = projectVariables
      @sysInstaller = getLinuxDistro()
    end

    def installApp()

      cf = CommonFunctions.new()
      newCmd = cf.substituteVariables(@params, @projectVariables)
      if newCmd.is_a?(Array)
        newCmd.each do | cmd |
          puts "Installing... #{cmd.colorize(:green)}"
          cf.processRun("#{@sysInstaller} #{cmd} -y")
        end
      else
        puts "Installing... #{@params.colorize(:green)}"
        cf.processRun("#{@sysInstaller} #{@params} -y")
      end

    end

    private def getLinuxDistro()
      io = IO::Memory.new
      Process.run("grep '^ID_LIKE' /etc/os-release", shell: true, output: io)
      linuxDistro = io.to_s.lchop("ID_LIKE=").chomp
      
      #puts linuxDistro

      case linuxDistro
      when "debian"
        @sysInstaller = "sudo apt-get install"
      else
        @sysInstaller = "unknown"
      end
    end

  end
end
