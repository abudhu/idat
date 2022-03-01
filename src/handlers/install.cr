require "toml"

module Idat
  class InstallFunctions
    def initialize(params)

      # This needs to figure out if you use Apt, Powershell, Choco, 
      # Then needs to figure out if you gave it an array
      # Or if its a single app
      # Or if the single link got subsituted and contains and array
      #puts params.is_a?(Array)
      #puts params.is_a?(String)
      puts "Installing... #{params.colorize(:green)}"
    end
  end
end
