require './command_runner'

class Main

  def self.run
    command_runner = CommandRunner.new
    while (cmd_line = $stdin.gets.strip) && cmd_line !~ /^exit|quit|q$/ do
      puts command_runner.run(cmd_line)
    end

    puts 'Bye!'
  end

end