require "toml"
require "./common.cr"

module Idat
  class InstallFunctions
    def initialize(params)

      # This needs to figure out if you use Apt, Powershell, Choco, 
      # Then needs to figure out if you gave it an array
      # Or if its a single app
      # Or if the single link got subsituted and contains and array
      #puts params.is_a?(Array)
      #puts params.is_a?(String)
      @params = params.as(String)
      @sysInstaller = getLinuxDistro()
      installApp()
    end

    def installApp()
      # Change to use common ProcessFunction
      puts "Installing... #{@params.colorize(:green)}"
      puts @sysInstaller
      cf = CommonFunctions.new()
      cf.processRun("#{@sysInstaller} #{@params} -y")
      #Process.run(@sysInstaller, args=@params, shell: true)
    end

    private def getLinuxDistro()
      io = IO::Memory.new
      Process.run("grep '^ID_LIKE' /etc/os-release", shell: true, output: io)
      linuxDistro = io.to_s.lchop("ID_LIKE=").chomp
      
      puts linuxDistro

      case linuxDistro
      when "debian"
        @sysInstaller = "sudo apt-get install"
      else
        @sysInstaller = "unknown"
      end
    end

  end
end
