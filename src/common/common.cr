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
    io = IO::Memory.new
    procError = IO::Memory.new

    runCmd = Process.run(cmd, shell: true, output: io, error: procError)       
    
    if procError.to_s.empty?
      idatLog(io)
      return io.to_s.colorize(:blue)
    else
      idatLog(procError)
      return procError.to_s.colorize(:red)
      Process.exit
    end
    io.close
    procError.close
  end

end
