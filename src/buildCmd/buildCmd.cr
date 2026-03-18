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

  define_flag dryRun : Bool,
    description: "Print commands without executing them",
    long: dryrun,
    short: d,
    required: false
  
  def run
    bf = BuildFunctions.new(flags.file, flags.dryRun || false)
    bf.executeSolution
  end
end
  