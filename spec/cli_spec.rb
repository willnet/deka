require 'spec_helper'

describe ReadmeTracker::Cli do
  describe '#run' do
    context 'when pass yaml_path as argument' do
      it "should git clone its repository" do
        path = File.expand_path('../support/sample.yml', __FILE__)
        cli = ReadmeTracker::Cli.new(yaml_path: path)
        expect(cli).to receive(:system).with("git clone git@github.com:willnet/readme_tracker.git")
        cli.run
      end
    end
  end
end
