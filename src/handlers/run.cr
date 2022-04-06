require "toml"
require "./common.cr"

module Idat
  class RunFunctions
    def initialize(runCmd, projectVariables)
      # Needs to define it as a string
      # Feature 2: Then needs to see if there are any [] for an array to do mutlirun
      @projectVariables = Hash(String, TOML::Type).new
      @runCmd = runCmd.as(String)
      @projectVariables = projectVariables
      puts "I enter run handler"
    end

    def execProcess

      cf = CommonFunctions.new()
      newCmd = cf.substituteVariables(@runCmd, @projectVariables)
      if newCmd.is_a?(Array)
        #puts "Got an Array of commands to run"
        newCmd.each do | cmd |
          cf.processRun(cmd)
        end
      else
        cf.processRun(newCmd.to_s)
      end
    end
  end
end
