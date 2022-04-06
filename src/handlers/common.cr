require "toml"

module Idat
  class CommonFunctions
    def initialize()

    end
    def processRun(cmd)
      #puts cmd
      io = IO::Memory.new
      procError = IO::Memory.new

      runCmd = Process.run(cmd, shell: true, output: io, error: procError)       
      
      if procError.to_s.empty?
        puts io.to_s.colorize(:blue)
      else
        puts procError.to_s.colorize(:red)
        Process.exit
      end
      io.close
      procError.close
    end

    def substituteVariables(action, projectVariables)



      # If you scan = and you encounter an ${} token
      # first check if the ${} = an Array

      areThereVariables = action.scan(/\${(.*)}/)
      if !areThereVariables.empty?
        explodeAction = action.split

        explodeAction.each_with_index do | item, position |
          isItemVariable = item.scan(/\${(.*)}/)
          if !isItemVariable.empty?
            # strip the variable of the ${}
            scrubbedItem = item.to_s.gsub("{", "").gsub("}","").gsub("$","")
          
            if projectVariables["projectVariables"].as(Hash)[(scrubbedItem)].to_s.starts_with?("[") && projectVariables["projectVariables"].as(Hash)[(scrubbedItem)].to_s.ends_with?("]") 
              # Its an array lets run it differently
              #puts "Its an Array Variable"

              arrayOfItemsToRun = Array(String).new
              
              itemArray = projectVariables["projectVariables"].as(Hash)[(scrubbedItem)].as(Array)
              
              itemArray.each do | subItem |
                  
                  myReturnValue = multiSub(action, subItem)
                  arrayOfItemsToRun.push(myReturnValue)
              end

              return arrayOfItemsToRun
                
            end

            replacementValue = projectVariables["projectVariables"].as(Hash)[(scrubbedItem)].to_s
            explodeAction[position] = replacementValue
            action = explodeAction.join(" ")
          end
        end  
        return action.as(String)
      end    

      
    end

  
    def multiSub(action, item)
      action = action.split
      action.each_with_index do | element, position |
        isElementVar = element.scan(/\${(.*)}/)
        if !isElementVar.empty?
          action[position] = item.to_s
        end
      end
      action = action.join(" ")      
    end
  end
end


# if it IS an array, then you need to count the number of items in the array
      # and duplicate the run command that many times

      # then for each run command, go get the element that matches the number.  so run command 1 uses, ${} item 1 in the spot
      # then send that off

      # isThereVariables = action.scan(/\${(.*)}/)
      # if !isThereVariables.empty?
      #   action = action.split
      #   #puts action
      #   #puts action.is_a?(Array)
      #   action.each_with_index do | element, position |
      #     #puts element
      #     #puts position
      #     isElementVar = element.scan(/\${(.*)}/)
      #     if !isElementVar.empty?
      #       cleanElement = element.to_s.gsub("{", "").gsub("}","").gsub("$","")
      #       #puts cleanElement

      #       replacementValue = projectVariables["projectVariables"].as(Hash)[(cleanElement)].to_s

      #       if projectVariables["projectVariables"].as(Hash)[(cleanElement)].to_s.starts_with?("[") && projectVariables["projectVariables"].as(Hash)[(cleanElement)].to_s.ends_with?("]") 
      #         elementArray = projectVariables["projectVariables"].as(Hash)[(cleanElement)].as(Array)
      #         elementArray.each do | element |
      #           puts element
      #           action[position] = element.to_s
                
      #         end
      #       else
      #         action[position] = replacementValue
      #       end            
      #     end
      #   end
      #   action = action.join(" ")
      #   puts action
      # end
      # return action.as(String)
