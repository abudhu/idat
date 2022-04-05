require "toml"
require "./common.cr"

module Idat
  class RunFunctions
    def initialize(params)
      # Needs to define it as a string
      # Feature 2: Then needs to see if there are any [] for an array to do mutlirun
      @params = params.as(String)
      execProcess()
    end

    def execProcess

      cf = CommonFunctions.new()
      cf.processRun(@params, args: nil)

    end
  end
end
