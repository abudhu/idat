require "toml"

class Common
  # Shell metacharacters that should never appear in variable values.
  # These could allow injection when values are substituted into shell commands.
  DANGEROUS_SHELL_PATTERNS = [
    /;/,             # command chaining
    /\|/,            # pipe
    /&&/,            # logical AND chaining
    /\|\|/,          # logical OR chaining
    /\$\(/,          # command substitution
    /`/,             # backtick command substitution
    />/,             # output redirection
    /</,             # input redirection
    /\n/,            # newline injection
    /\r/,            # carriage return injection
  ]

  def initialize(filePath)
    tomlString = filePath.as(String)
    tomlFile = File.read(tomlString)
    @tomlData = TOML.parse(tomlFile)
    typeof(@tomlData)
  end
  def projectInfo
    @tomlData["projectInfo"].as(Hash)   
  end

  def projectSettings
    @tomlData["projectSettings"].as(Hash)
  end
  
  def projectVariables
    @tomlData["projectVariables"].as(Hash)
  end

  def projectSteps
    @tomlData.reject("projectInfo","projectSettings","projectVariables")
  end

  def projectLogFile
    projInfo = projectInfo
    logFileName = projectInfo["name"].as(String).gsub(" ","")
    "/tmp/#{logFileName}.log"
  end

  def idatLog(logItem)
    File.new(projectLogFile, mode="ab+")
    File.write(projectLogFile, "#{logItem}\n", mode: "a")
  end

  def processRun(cmd)
    #puts cmd
    io = IO::Memory.new
    procError = IO::Memory.new

    runCmd = Process.run(cmd, shell: true, output: io, error: procError)       
    if runCmd.exit_code == 0
      idatLog(io)
      # Make this so if they flag in settings that they want output, then display it
      returnValue = "Successfully ran...#{cmd}".colorize(:green)
      return returnValue
      #return io.to_s.colorize(:white)
    elsif runCmd.exit_code == 1
      idatLog(procError)
      returnValue = "WARNING... #{procError.to_s}".colorize(:yellow)
      return returnValue
    else
      #TODO: Make this error more user friendly, most likely yuo
      # will need to wrap it in begin rescue
      idatLog(procError)
      raise procError.to_s 
    end
  end

  def substituteVariables(cmd)
    idatLog("Substituting any variables for: #{cmd}")

    pv = projectVariables()

    areThereVariables = cmd.scan(/\${(.*)}/)
    if !areThereVariables.empty?
      explodeCmd = cmd.split
      explodeCmd.each_with_index do | item, position |
        isItemVariable = item.scan(/\${(.*)}/)
        if !isItemVariable.empty?
          # strip the variable of the ${}
          scrubbedItem = item.to_s.gsub("{", "").gsub("}","").gsub("$","")

          if pv[(scrubbedItem)].to_s.starts_with?("[") && pv[(scrubbedItem)].to_s.ends_with?("]") 
            arrayOfItemsToRun = Array(String).new
            
            itemArray = pv[(scrubbedItem)].as(Array)

            itemArray.each do | subItem |
              validate_variable_value(scrubbedItem, subItem.to_s)
              myReturnValue = multiSub(explodeCmd, subItem, position)
              arrayOfItemsToRun.push(myReturnValue)
            end
            return arrayOfItemsToRun
          end

          replacementValue = pv[(scrubbedItem)].to_s
          validate_variable_value(scrubbedItem, replacementValue)
          explodeCmd[position] = replacementValue
          cmd = explodeCmd.join(" ")
        end
      end  
      return cmd.as(String)
    else
      return cmd
    end   

  end

  private def validate_variable_value(variable_name : String, value : String)
    DANGEROUS_SHELL_PATTERNS.each do |pattern|
      if value.matches?(pattern)
        error_message = "Unsafe variable value detected — variable '#{variable_name}' contains dangerous shell characters: #{value.inspect}"
        idatLog("SECURITY ERROR: #{error_message}")
        raise error_message
      end
    end
  end

  private def multiSub(action, item, position)
    action[position] = item.to_s
    action = action.join(" ")
  end

  def getSystem()
    {% if flag?(:linux) %}
      os = "Linux"
    {% elsif flag?(:darwin) %}
      os = "Mac"
    {% elsif flag?(:win32) %}
      os = "Windows"
    {% else %}
      os = "Unsupported"
    {% end %}
  end

end
