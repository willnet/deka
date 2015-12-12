require 'spec_helper'

describe Deka::Cli do
  describe '#run' do
    context 'when pass config and save_file as argument' do
      let(:config) { './spec/support/sample.yml' }
      let(:save_file) { './spec/support/.tracked_hash' }
      let!(:old_hash_txt) { File.read(save_file) }

      after do
        File.open(save_file, 'w') do |file|
          file.write(old_hash_txt)
        end
      end

      it 'should git clone its repository and write new hash to save_file' do
        cli = Deka::Cli.new(config: config, save: save_file)
        expect(cli).to receive(:system)
          .with('git clone https://github.com/willnet/readme_tracker_watching_repo.git')
          .and_call_original
        expect(cli.client).to receive(:create_issue)
          .with('willnet/readme_tracker_issuing_repo', 'about 670f679', "please respond\n\nhttps://github.com/willnet/readme_tracker_watching_repo/commit/670f67987f9616a020f91e00f146090617b06e8a")
        expect(cli.client).to receive(:create_issue)
          .with('willnet/readme_tracker_issuing_repo', 'about ccd8832', "please respond\n\nhttps://github.com/willnet/readme_tracker_watching_repo/commit/ccd88321b9cca4ceb24fdb09c3e338656c6300fa")
        cli.run
        new_hash_txt = File.read(save_file)
        expect(new_hash_txt).to eq 'ccd88321b9cca4ceb24fdb09c3e338656c6300fa'
      end

      context 'and pass dry-run is true' do
        it 'should dry run' do
          cli = Deka::Cli.new(
            config: config,
            save: save_file,
            'dry-run': true
          )
          expect(cli).to receive(:system)
            .with('git clone https://github.com/willnet/readme_tracker_watching_repo.git')
            .and_call_original
          expect(cli.client).not_to receive(:create_issue)
          cli.run
          new_hash_txt = File.read(save_file).chomp
          expect(new_hash_txt).to eq '6ed23d83705e2cf864cc2fa7d1307e0f8131b1b9'
        end
      end
    end
  end
end
