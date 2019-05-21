require 'pry'
require "./album_service"

describe AlbumService do
  let(:album_service) { described_class.new(album_store) }
  let(:album_store) { Hash.new }

  describe "#add" do
    let(:title) { 'fake_title' }
    let(:artist) { 'fake artist' }

    subject do
      album_service.add(title, artist)
    end

    it "adds an element to album_store" do
      expect { subject }.to change(album_store, :count).from(0).to(1)
    end

    it "returns display listing for album" do
      expect(subject).to eq("Added \"fake_title\" by fake artist")
    end

    context "album by title already exists" do
      it "returns error message" do
        subject
        expect(album_service.add(title, artist)).to eq("Album by the name \"fake_title\" already exists")
      end
    end
  end

  describe "#play" do
    let(:title) { 'fake_title' }
    let(:artist) { 'fake artist' }

    it "returns error message" do
      expect(album_service.play(title)).to eq("Album by the name \"fake_title\" not found")
    end

    context "album by title exists" do
      before do
        album_service.add(title, artist)
      end

      it "saves album as 'played'" do
        expect { album_service.play(title) }.to change(album_store[title], :played).from(false).to(true)
      end

      it "returns success message" do
        expect(album_service.play(title)).to eq("You're listening to \"fake_title\"")
      end
    end
  end

  describe "#show" do
    let(:title) { 'fake_title' }
    let(:artist) { 'fake artist' }

    it "returns no results" do
      expect(album_service.show(title, nil)).to be_empty
    end

    context "3 albums have been added" do
      before do
        album_service.add('existing_album_one', 'existing_artist_one')
        album_service.add('existing_album_two', 'existing_artist_one')
        album_service.add('existing_album_three', 'existing_artist_two')
      end

      context "param filter: 'all'" do
        it "lists all 3 albums" do
          expect(album_service.show('all', nil)).to include('existing_album_one', 'existing_album_two', 'existing_album_three')
        end

        context "param artist: 'existing_artist_one'" do
          it "lists the 2 albums from 'existing_artist_one'" do
            expect(album_service.show('all', 'existing_artist_one')).to include('existing_album_one', 'existing_album_two')
          end

          it "does not list the album from other artists" do
            expect(album_service.show('all', 'existing_artist_one')).to_not include('existing_album_three')
          end
        end
      end

      context "param filter: 'unplayed'" do
        context "param artist: nil" do
          it "lists all 3 albums" do
            expect(album_service.show('unplayed', nil)).to include('existing_album_one', 'existing_album_two', 'existing_album_three')
          end
        end

        context "param artist: 'existing_artist_one'" do
          it "lists the 2 albums from 'existing_artist_one'" do
            expect(album_service.show('unplayed', 'existing_artist_one')).to include('existing_album_one', 'existing_album_two')
          end

          it "does not list the album from other artists" do
            expect(album_service.show('unplayed', 'existing_artist_one')).to_not include('existing_album_three')
          end
        end

        context "one album has been played" do
          before do
            album_service.play('existing_album_two')
          end

          context "param artist: nil" do
            it "lists 2 unplayed albums" do
              expect(album_service.show('unplayed', nil)).to include('existing_album_one', 'existing_album_three')
            end

            it "does not list the unplayed album" do
              expect(album_service.show('unplayed', nil)).to_not include('existing_album_two')
            end
          end

          context "param artist: 'existing_artist_one'" do
            it "lists the 1 unplayed from 'existing_artist_one'" do
              expect(album_service.show('unplayed', 'existing_artist_one')).to include('existing_album_one')
            end

            it "does not list the unplayed album from 'existing_artist_one'" do
              expect(album_service.show('unplayed', 'existing_artist_one')).to_not include('existing_album_two')
            end

            it "does not list the albums from other artists" do
              expect(album_service.show('unplayed', 'existing_artist_one')).to_not include('existing_album_three')
            end
          end
        end

      end

      context "album 3 has been played" do
        context "param filter: 'all'" do
          it "lists all 3 albums" do
            expect(album_service.show('all', nil)).to include('existing_album_one', 'existing_album_two', 'existing_album_three')
          end
        end

        context "param filter: 'unplayed'" do
          it "does not list played album" do
            album_service.play('existing_album_three')
            expect(album_service.show('unplayed', nil)).to_not include('existing_album_three')
          end
        end

      end
    end
  end
end