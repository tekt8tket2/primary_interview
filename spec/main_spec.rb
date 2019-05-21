require 'pry'
require "./main"

describe Main do
  let(:command_line) { 'invalid command' }

  it "receives commands from stdin" do
    allow($stdout).to receive(:puts) # Supresses stdout for cleaner console output

    expect($stdin).to receive(:gets).and_return(command_line, 'exit')
    Main.run
  end

  it "returns messages to stdout" do
    allow($stdin).to receive(:gets).and_return(command_line, 'exit')

    expect { Main.run }.to output.to_stdout
  end

  it "prints quit message to stdout" do
    allow($stdin).to receive(:gets).and_return(command_line, 'exit')

    expect { Main.run }.to output(/Bye!/).to_stdout
  end
end
