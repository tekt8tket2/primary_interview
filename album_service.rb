require './album'

class AlbumService

	def initialize(album_store=Hash.new)
		@album_store = album_store
	end

	def add(album_name, artist_name)
		return "Album by the name \"#{album_name}\" already exists" if @album_store.has_key?(album_name)

		@album_store[album_name] = Album.new(album_name, artist_name)

		"Added \"#{album_name}\" by #{artist_name}"
	end

	def play(album_name)
		return "Album by the name \"#{album_name}\" not found" unless @album_store.has_key?(album_name)

		@album_store[album_name].play
		"You're listening to \"#{album_name}\""
	end

	def show(filter, artist_name)
		filtered_albums = @album_store.values
		filtered_albums.select! { |album| album.artist == artist_name } if artist_name
		filtered_albums.select! { |album| !album.played } if filter == 'unplayed'

		filtered_albums.map do |album|
			album.listing_string
		end.join("\n")
	end

end