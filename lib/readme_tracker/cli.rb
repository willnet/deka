require 'yaml'
require 'fileutils'

class ReadmeTracker::Cli
  attr_accessor :yaml_path, :bash_hash

  def self.run(config = {})
    new(config).run
  end

  def initialize(config)
    @yaml_path = config[:yaml_path] || './readme_tracker.yml'
    hash_path = config[:hash_path] || './hash.txt'
    @base_hash = File.read(hash_path).chomp
  end

  def run
    yaml = YAML.load(File.read(yaml_path))
    repository_name = yaml['repo'].split('/')[1]
    system "git clone https://github.com/#{yaml['repo']}.git"

    FileUtils.cd repository_name
    log = `git log --oneline README.md`
    all_hashes = log.each_line.map { |line| line.strip[0..6] }
    issue_hashes = all_hashes.take_while { |hash| hash != base_hash }

    # TODO: make issues on user's repository from issue_hashes
    # TODO: overwrite hash.txt
  end
end
