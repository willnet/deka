require 'spec_helper'

describe ReadmeTracker::Cli do
  describe '#run' do
    context 'when pass yaml_path and hash_path as argument' do
      let(:yaml_path) { File.expand_path('../support/sample.yml', __FILE__) }
      let(:hash_path) { File.expand_path('../support/hash.txt', __FILE__) }
      let!(:old_hash_txt) { File.read(hash_path) }

      after do
        File.open(hash_path, 'w') do |file|
          file.write(old_hash_txt)
        end
      end

      it "should git clone its repository and write new hash to hash_path" do
        cli = ReadmeTracker::Cli.new(yaml_path: yaml_path, hash_path: hash_path)
        expect(cli).to receive(:system).
          with("git clone https://github.com/willnet/readme_tracker_watching_repo.git").
          and_call_original
        expect(cli.client).to receive(:create_issue).
          with('willnet/readme_tracker_issuing_repo', 'about 670f679', "please respond\n\n670f679")
        expect(cli.client).to receive(:create_issue).
          with('willnet/readme_tracker_issuing_repo', 'about ccd8832', "please respond\n\nccd8832")
        cli.run
        new_hash_txt = File.read(hash_path)
        expect(new_hash_txt).to eq 'ccd8832'
      end

      context 'and pass dry-run is true' do
        it 'should dry run' do
          cli = ReadmeTracker::Cli.new(
            yaml_path: yaml_path,
            hash_path: hash_path,
            :'dry-run' => true
          )
          expect(cli).to receive(:system).
            with("git clone https://github.com/willnet/readme_tracker_watching_repo.git").
            and_call_original
          expect(cli.client).not_to receive(:create_issue)
          cli.run
          new_hash_txt = File.read(hash_path).chomp
          expect(new_hash_txt).to eq '6ed23d8'
        end
      end
    end
  end
end
