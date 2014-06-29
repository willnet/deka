require 'spec_helper'

describe ReadmeTracker::Cli do
  describe '#run' do
    context 'when pass yaml_path as argument' do
      it "should git clone its repository" do
        yaml_path = File.expand_path('../support/sample.yml', __FILE__)
        hash_path = File.expand_path('../support/hash.txt', __FILE__)
        cli = ReadmeTracker::Cli.new(yaml_path: yaml_path, hash_path: hash_path)
        expect(cli).to receive(:system).with("git clone https://github.com/willnet/readme_tracker.git").and_call_original
        cli.run
      end
    end
  end
end
