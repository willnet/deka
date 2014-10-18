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
          with('willnet/readme_tracker_issuing_repo', 'about 670f679', "please respond\n\nhttps://github.com/willnet/readme_tracker_watching_repo/commit/670f67987f9616a020f91e00f146090617b06e8a")
        expect(cli.client).to receive(:create_issue).
          with('willnet/readme_tracker_issuing_repo', 'about ccd8832', "please respond\n\nhttps://github.com/willnet/readme_tracker_watching_repo/commit/ccd88321b9cca4ceb24fdb09c3e338656c6300fa")
        cli.run
        new_hash_txt = File.read(hash_path)
        expect(new_hash_txt).to eq 'ccd88321b9cca4ceb24fdb09c3e338656c6300fa'
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
          expect(new_hash_txt).to eq '6ed23d83705e2cf864cc2fa7d1307e0f8131b1b9'
        end
      end
    end
  end
end
