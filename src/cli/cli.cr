require "admiral"
require "../**"

class CLI < Admiral::Command
  define_help
  register_sub_command build, Builder
  def run
    puts help
  end
end
