require 'yaml'
require 'fileutils'
require 'octokit'

class ReadmeTracker::Cli
  attr_accessor :yaml_path, :base_hash, :yaml

  def self.run(config = {})
    new(config).run
  end

  def initialize(config)
    @yaml_path = config[:yaml_path] || './readme_tracker.yml'
    hash_path = config[:hash_path] || './hash.txt'
    @base_hash = File.read(hash_path).chomp
  end

  def yaml
    @yaml = YAML.load(File.read(yaml_path))
  end

  def watching_repo
    yaml['watching_repo']
  end

  def issuing_repo
    yaml['watching_repo']
  end

  def access_token
    yaml['access_token']
  end

  def client
    @client ||= Octokit::Client.new(access_token: access_token)
  end

  def run
    repository_name = watching_repo.split('/')[1]

    system "git clone https://github.com/#{watching_repo}.git"

    FileUtils.cd repository_name
    log = `git log --oneline README.md`
    all_hashes = log.each_line.map { |line| line.strip[0..6] }
    issue_hashes = all_hashes.take_while { |hash| hash != base_hash }

    issue_hashes.each do |issue_hash|
      title = "about #{issue_hash}"
      body = if yaml['body']
               yaml['body'] + "\n\n#{issue_hash}"
             else
               "please respond \n\n#{issue_hash}"
             end
      client.create_issue(issuing_repo, title, body)
    end

    File.open(hash_path, 'w') do |file|
      file.print(issue_hashes.last)
    end
  ensure
    if File.exist?(repository_name)
      FileUtils.rm_r repository_name
    end
  end
end
