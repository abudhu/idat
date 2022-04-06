require "toml"
require "./common.cr"

module Idat
  class InstallFunctions
    @params : Array(TOML::Type) | String
    def initialize(params, projectVariables)
      @projectVariables = Hash(String, TOML::Type).new
      # This needs to figure out if you use Apt, Powershell, Choco, 
      # Then needs to figure out if you gave it an array
      # Or if its a single app
      # Or if the single link got subsituted and contains and array
      
      if params.is_a?(Array)
        @params = params.as(Array)
      else
        @params = params.as(String)
      end
      @projectVariables = projectVariables
      @sysInstaller = getLinuxDistro()
    end

    def installApp()
      cf = CommonFunctions.new()
      
      if @params.is_a?(Array)
        @params.as(Array).each do | app |
          puts "Installing... #{app.colorize(:green)}"
          cf.processRun("#{@sysInstaller} #{app} -y")
        end
      else
        newCmd = cf.substituteVariables(@params.as(String), @projectVariables)
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
