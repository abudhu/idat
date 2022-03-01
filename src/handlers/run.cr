require "toml"

module Idat
  class RunFunctions
    def initialize(params)
      # Needs to define it as a string
      # Then needs to see if there are any [] for an array to do mutlirun
      @params = params.as(String)
      puts "Running... #{@params.colorize(:cyan)}"
    end
  end
end