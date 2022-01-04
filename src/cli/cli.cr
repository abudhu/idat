require "admiral"
require "../**"

module Idat
  class CLI < Admiral::Command
    define_help

    register_sub_command validate, Idat::Validator

    register_sub_command build, Idat::Builder
  
    def run
      puts help
    end
  end
end