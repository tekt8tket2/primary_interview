require './album_store'

class CommandRunner

	def initialize(store=AlbumStore.new)
		@album_store = store
	end

	def run(command_line)
		case command_line
			# Usage: add "$title" "$artist": adds an album to the collection with the given title and artist. All albums are unplayed by default.
			when /^add\s(?:\"(?<album_name>[\w\s]+)\"|(?<album_name>\w+))\s(?:\"(?<artist_name>[\w\s]+)\"|(?<artist_name>\w+))$/
				self.add($~[:album_name], $~[:artist_name])
			else
				return "Invalid Command: #{command_line}"
		end
	end

	def add(album_name, artist_name)
		@album_store.add(album_name, artist_name)
		return "Added \"#{album_name}\" by #{artist_name}"
	end
end