require './album_service'

class CommandRunner

  ADD_COMMAND_REGEX = %r{
    ^add\s
    (?:\"(?<album_name>[\w\s]+)\"|(?<album_name>\w+))\s
    (?:\"(?<artist_name>[\w\s]+)\"|(?<artist_name>\w+))$
  }x

  PLAY_COMMAND_REGEX = %r{
    ^play\s
    (?:\"(?<album_name>[\w\s]+)\"|(?<album_name>\w+))$
  }x

  SHOW_COMMAND_REGEX = %r{
    ^show\s
    (?<album_filter>all|unplayed)
    (?:\sby\s(?:
      \"(?<artist_name>[\w\s]+)\"|(?<artist_name>\w+)))?$
  }x

  def initialize(album_service=AlbumService.new)
    @album_service = album_service
  end

  def run(command_string)
    case command_string
      when ADD_COMMAND_REGEX
        # Usage: add "$title" "$artist": adds an album to the collection with the given title and artist. All albums are unplayed by default.
        @album_service.add($~[:album_name], $~[:artist_name])
      when PLAY_COMMAND_REGEX
        # Usage: play "$title": marks a given album as played.
        @album_service.play($~[:album_name])
      when SHOW_COMMAND_REGEX
        # show all: displays all of the albums in the collection
        # show unplayed: display all of the albums that are unplayed
        # show all by "$artist": shows all of the albums in the collection by the given artist
        # show unplayed by "$artist": shows the unplayed albums in the collection by the given artist
        @album_service.show($~[:album_filter], $~[:artist_name])
    else
      "Invalid Command: #{command_string}"
    end
  end

end