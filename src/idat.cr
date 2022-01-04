require "option_parser"
require "./runner.cr"

module Idat
  VERSION = "0.1.0"

  OptionParser.parse do | parser |
    parser.banner = "I Did A Thing - A Simple Automation Tool"

    parser.on "-f FILE", "--file=FILE", "TOML Automation File" do | file | 
      runner = Runner.new(file)
      runner.execute()
    end

    parser.on "-h", "--help", "Show Help" do
      puts parser
    end

  end

end


