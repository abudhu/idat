require "toml"

module Idat
  class CommonFunctions
    def initialize()

    end
    def processRun(cmd, args)
      io = IO::Memory.new
      procError = IO::Memory.new

      if args.nil?
        runCmd = Process.run(cmd, shell: true, output: io, error: procError)
      else
        runCmd = Process.run(cmd, args, shell: true, output: io, error: procError)
      end
        
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
