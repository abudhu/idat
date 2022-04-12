class ValidateFunctions
  def initialize(file)
    # if you parse the file
    # and get the common top info
    # you can then send it to common
    # and then you can do common.name / common.file / common.log??
    cf = Common.new(file)
    puts cf.projectInfo
    puts cf.projectSettings
    puts cf.projectVariables
    puts cf.projectSteps
    puts cf.projectLogFile
    cf.idatLog("This came from Validate")
  end
end