module Idat
  class Builder < Admiral::Command
    define_help
    define_flag file,
      description: "TOML Solution to build",
      long: file,
      short: f,
      required: true

    define_flag ignoreValidation : Bool,
      description: "Skip validation test",
      long: ignorevalidation,
      short: iv,
      required: false

    def run

      bf = BuilderFunctions.new(flags.file)

      if flags.ignoreValidation
        puts "Ignoring Validation"
      else
        vf = ValidatorFunctions.new(flags.file)

        vf.validateToml
        vf.validateSystem
      end

      #bf.substituteVariables
      bf.executeSolution

    end
  end
end
