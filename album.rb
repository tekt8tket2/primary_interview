class Album
  attr_reader :played, :artist

  def initialize(title, artist)
    @title = title
    @artist = artist
    @played = false
  end

  def play
    @played = true
  end

  def listing_string
    "\"#{@title}\" by #{@artist} (#{played_string})"
  end

private

  def played_string
    if @played
      'played'
    else
      'unplayed'
    end
  end

end