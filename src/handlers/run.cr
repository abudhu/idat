require "toml"

module Idat
  class RunFunctions
    def initialize(params)
      # Needs to define it as a string
      # Feature 2: Then needs to see if there are any [] for an array to do mutlirun
      @params = params.as(String)
      execProcess()
    end

    def execProcess
      puts "Running... #{@params.colorize(:cyan)}"

      io = IO::Memory.new
      procError = IO::Memory.new

      runCmd = Process.run(@params, shell: true, output: io, error: procError)
      if procError.to_s.empty?
        puts io.to_s.colorize(:blue)
      else
        puts procError.to_s.colorize(:red)
        Process.exit
      end
      io.close
      procError.close
    end
  end
end
