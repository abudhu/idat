module Idat
  class Validator
    def initalize(toml_file)
      @toml_file = toml_file.as(Hash)
    end
  end

  def validateToml
    unless @toml_file.has_key?("projectInfo") && @toml_file.has_key?("projectSettings")
      puts "has all keys"
    else
      raise "doesn't have required info"
    end
  end

end
