require 'pry'
require "./main"

describe CommandRunner do
	subject { described_class.new(store).run(command) }
	let(:store) { AlbumStore.new }

	context "receives an invalid command" do
		let(:command) { 'invalid command' }		
		let(:expected_output) { 'Invalid Command: invalid command' }

		it "returns invalid message" do
			expect(subject).to eq(expected_output)
		end
	end

	describe ".add" do

		context "with no double quotes and one word parameters" do		
			let(:command) { 'add fake_album fake_artist' }		
			let(:expected_output) { 'Added "fake_album" by fake_artist' }

			it "calls AlbumStore#add" do
				expect(store).to receive(:add).with('fake_album', 'fake_artist')
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
end