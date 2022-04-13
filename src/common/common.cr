require "toml"

class Common
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
    puts cmd
    io = IO::Memory.new
    procError = IO::Memory.new

    runCmd = Process.run(cmd, shell: true, output: io, error: procError)       
    
    if procError.to_s.empty?
      idatLog(io)
      return io.to_s.colorize(:white)
    else
      idatLog(procError)
      raise "#{procError}"
      #return procError.to_s.colorize(:red)
    end
    io.close
    procError.close
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
            #puts "The Array Variable is at #{position}"
            # Its an array lets run it differently
            #puts "Its an Array Variable"

            arrayOfItemsToRun = Array(String).new
            
            itemArray = pv[(scrubbedItem)].as(Array)
            
            itemArray.each do | subItem |
              myReturnValue = multiSub(explodeCmd, subItem, position)
              arrayOfItemsToRun.push(myReturnValue)
            end
            return arrayOfItemsToRun
          end

          replacementValue = pv[(scrubbedItem)].to_s
          explodeCmd[position] = replacementValue
          cmd = explodeCmd.join(" ")
        end
      end  
      return cmd.as(String)
    else
      return cmd
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
