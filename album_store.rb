class AlbumStore

	def initialize
		@store = []
	end

	def add(title, artist)
		@store << { artist: artist, name: title, play_count: 0 } unless exists?(title, artist)
	end

	def exists?(title, artist)
		@store.any? do |album|
			album[:title] == title && album[:artist] == artist
		end
	end

end