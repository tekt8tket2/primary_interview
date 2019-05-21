require 'pry'
require "./main"

# Integration Tests
describe CommandRunner do
	subject { command_runner.run(command) }
	let(:command_runner) { described_class.new(album_service) }
	let(:album_service) { AlbumService.new(album_store) }
	let(:album_store) { Hash.new }

	context "receives an invalid command" do
		let(:command) { 'invalid command' }
		let(:expected_output) { 'Invalid Command: invalid command' }

		it "returns invalid message" do
			expect(subject).to eq(expected_output)
		end
	end

	describe "'add' command" do
		subject { command_runner.run(command) }

		context "with no double quotes and one word parameters" do
			let(:command) { 'add fake_album fake_artist' }
			let(:expected_output) { 'Added "fake_album" by fake_artist' }

			it "calls AlbumStore#add" do
				expect(album_service).to receive(:add).with('fake_album', 'fake_artist')
				subject
			end

			it "returns success message" do
				expect(subject).to eq(expected_output)
			end
		end

		context "with double quotes around first parameter" do
			let(:command) { 'add "fake album" fake_artist' }
			let(:expected_output) { 'Added "fake album" by fake_artist' }

			it "returns success message" do
				expect(subject).to eq(expected_output)
			end
		end

		context "with double quotes around second parameter" do
			let(:command) { 'add fake_album "fake artist"' }
			let(:expected_output) { 'Added "fake_album" by fake artist' }

			it "returns success message" do
				expect(subject).to eq(expected_output)
			end
		end

		context "with no parameters" do
			let(:command) { 'add' }
			let(:expected_output) { 'Invalid Command: add' }

			it "returns invalid message" do
				expect(subject).to eq(expected_output)
			end
		end

		context "with too few parameters" do
			let(:command) { 'add fake_album' }
			let(:expected_output) { 'Invalid Command: add fake_album' }

			it "returns invalid message" do
				expect(subject).to eq(expected_output)
			end
		end

		context "with too many parameters" do
			let(:command) { 'add fake_album fake_artist extra_param' }
			let(:expected_output) { 'Invalid Command: add fake_album fake_artist extra_param' }

			it "returns invalid message" do
				expect(subject).to eq(expected_output)
			end
		end
	end

	describe "'play' command" do
		let(:existing_album_name) { 'valid_album' }

		before do
			album_service.add(existing_album_name, 'valid_artist')
		end

		context "with no parameters" do
			let(:command) { 'play' }
			let(:expected_output) { 'Invalid Command: play' }

			it "returns invalid message" do
				expect(subject).to eq(expected_output)
			end
		end

		context "with valid parameters" do
			let(:command) { 'play valid_album' }
			let(:expected_output) { "You're listening to \"valid_album\"" }

			it "calls AlbumStore#add" do
				expect(album_service).to receive(:play).with('valid_album')
				subject
			end

			it "returns success message" do
				expect(subject).to eq(expected_output)
			end

			it "saves the album as played" do
				expect { subject }.to change { album_store['valid_album'].played }.from(false).to(true)
			end
		end

		context "with double quotes around valid parameters" do
			let(:command) { 'play "valid album with spaces"' }
			let(:existing_album_name) { 'valid album with spaces' }
			let(:expected_output) { "You're listening to \"valid album with spaces\"" }

			it "returns success message" do
				expect(subject).to eq(expected_output)
			end

			it "saves the album as played" do
				expect { subject }.to change { album_store['valid album with spaces'].played }.from(false).to(true)
			end
		end

		context "with too many parameters" do
			let(:command) { 'play fake_album extra_param' }
			let(:expected_output) { 'Invalid Command: play fake_album extra_param' }

			it "returns invalid message" do
				expect(subject).to eq(expected_output)
			end
		end

		context "with album_name not found" do
			let(:command) { 'play unknown_album' }
			let(:expected_output) { "Album by the name \"unknown_album\" not found" }

			it "returns invalid message" do
				expect(subject).to eq(expected_output)
			end
		end
	end

	describe "'show' command" do
		context "with no parameters" do
			let(:command) { 'show' }
			let(:expected_output) { 'Invalid Command: show' }

			it "returns invalid message" do
				expect(subject).to eq(expected_output)
			end
		end

		context "with invalid filter parameter" do
			let(:command) { 'show invalid_filter' }
			let(:expected_output) { 'Invalid Command: show invalid_filter' }

			it "returns invalid message" do
				expect(subject).to eq(expected_output)
			end
		end

		context "with filter parameter 'all'" do
			let(:command) { 'show all' }

			it "returns no results" do
				expect(subject).to be_empty
			end

			context "with existing albums" do
				before do
					album_service.add('existing_album_one', 'valid_artist_one')
					album_service.add('existing_album_two', 'valid_artist_one')
					album_service.add('existing_album_three', 'valid_artist_two')
				end

				let(:expected_output) do
					"\"existing_album_one\" by valid_artist_one (unplayed)\n\"existing_album_two\" by valid_artist_one (unplayed)\n\"existing_album_three\" by valid_artist_two (unplayed)"
				end

				it "returns results for all albums" do
					expect(subject).to eq(expected_output)
				end

				context "with second parameter 'by valid_artist_one'" do
					let(:command) { 'show all by valid_artist_one' }
					let(:expected_output) do
						"\"existing_album_one\" by valid_artist_one (unplayed)\n\"existing_album_two\" by valid_artist_one (unplayed)"
					end

					it "returns results for artist: 'valid_artist_one'" do
						expect(subject).to eq(expected_output)
					end
				end
			end
		end

		context "with filter parameter 'unplayed'" do
			let(:command) { 'show unplayed' }

			it "returns no results" do
				expect(subject).to be_empty
			end

			context "with all existing albums played" do
				before do
					album_service.add('existing_album_one', 'valid_artist_one')
					album_service.add('existing_album_two', 'valid_artist_one')
					album_service.add('existing_album_three', 'valid_artist_two')
					album_service.play('existing_album_one')
					album_service.play('existing_album_two')
					album_service.play('existing_album_three')
				end

				it "returns no results" do
					expect(subject).to be_empty
				end
			end

			context "with some existing played albums" do
				before do
					album_service.add('existing_album_one', 'valid_artist_one')
					album_service.add('existing_album_two', 'valid_artist_one')
					album_service.add('existing_album_three', 'valid_artist_two')
					album_service.play('existing_album_one')
				end
				let(:expected_output) do
					"\"existing_album_two\" by valid_artist_one (unplayed)\n\"existing_album_three\" by valid_artist_two (unplayed)"
				end

				it "returns results for unplayed albums" do
					expect(subject).to eq(expected_output)
				end

				context "with second parameter 'by valid_artist_one'" do
					let(:command) { 'show unplayed by valid_artist_one' }
					let(:expected_output) do
						"\"existing_album_two\" by valid_artist_one (unplayed)"
					end

					it "returns unplayed results for artist: 'valid_artist_one'" do
						expect(subject).to eq(expected_output)
					end
				end
			end
		end
	end
end