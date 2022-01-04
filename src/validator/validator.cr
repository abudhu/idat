require "./*"

module Idat
  class Validator < Admiral::Command
    define_flag file,
      description: "TOML Solution to validate",
      long: file,
      short: f,
      required: true

    def run
      puts "excellent - you entered validator"

      vf = ValidatorFunctions.new(flags.file)

      vf.validateToml
      vf.validateSystem
    end
  end
end
