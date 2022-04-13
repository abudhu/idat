class AppendHandler
  def initialize(argument, file)
    @appendInfo = argument.as(Array(TOML::Type))
    @cf = Common.new(file)
  end

  def append
    lineToAdd = @appendInfo[0].as(String)
    pathToFile = @appendInfo[1].as(String)
    @cf.idatLog("Appending Line: #{lineToAdd} to: #{pathToFile}")
    puts "Appending Line... #{lineToAdd.colorize.mode(:bold)} to #{pathToFile.colorize.mode(:bold)}"
    File.write(pathToFile, lineToAdd, mode: "a")
  end
end
