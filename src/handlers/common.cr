require "toml"

module Idat
  class commonFunctions
    def initialize(cmd, args)
      @cmd = cmd
      @args = args
    end
    def processRun(@cmd, @args)
      io = IO::Memory.new
      procError = IO::Memory.new

      runCmd = Process.run(@cmd, @args, shell: true, output: io, error: procError)
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
