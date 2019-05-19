require './command_runner'
require 'pry'

class Main

	def self.run
		while (cmd_line = $stdin.gets.strip) && cmd_line !~ /^exit|quit|q$/ do
			puts CommandRunner.new.run(cmd_line)
		end

		puts 'Bye!'
	end

end