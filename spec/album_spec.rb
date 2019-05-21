require 'pry'
require "./album"

describe Album do
  subject { described_class.new(title, artist) }
  let(:title) { 'fake_title' }
  let(:artist) { 'fake artist' }

  it "returns default listing" do
    expect(subject.listing_string).to eq('"fake_title" by fake artist (unplayed)')
  end

  context "#play" do
    it "returns listing as 'played'" do
      expect { subject.play }.to change(subject, :listing_string)
        .from('"fake_title" by fake artist (unplayed)')
        .to('"fake_title" by fake artist (played)')
    end
  end
end