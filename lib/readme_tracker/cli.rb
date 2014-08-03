require 'yaml'
require 'fileutils'
require 'octokit'

class ReadmeTracker::Cli
  attr_accessor :yaml_path, :base_hash, :yaml, :hash_path

  def self.run(config = {})
    new(config).run
  end

  def initialize(config)
    @yaml_path = config[:yaml_path] || './readme_tracker.yml'
    @hash_path = config[:hash_path] || './hash.txt'
    @base_hash = File.read(hash_path).chomp
  end

  def yaml
    @yaml = YAML.load(File.read(yaml_path))
  end

  def watching_repo
    yaml['watching_repo']
  end

  def issuing_repo
    yaml['issuing_repo']
  end

  def access_token
    yaml['access_token']
  end

  def directory_name
    watching_repo.split('/')[1]
  end

  def client
    @client ||= Octokit::Client.new(access_token: access_token)
  end

  def issue_title(issue_hash)
    "about #{issue_hash}"
  end

  def issue_body(issue_hash)
    if yaml['body']
      yaml['body'] + "\n\n#{issue_hash}"
    else
      "please respond \n\n#{issue_hash}"
    end
  end

  def fetch_log
    system "git clone https://github.com/#{watching_repo}.git"
    log = ''
    FileUtils.cd directory_name do
      log = `git log --oneline README.md`
    end
    log
  end

  def update_lastest_hash(latest_hash)
    File.open(hash_path, 'w') do |file|
      file.write(latest_hash)
    end
  end

  def delete_temp_repo
    if File.exist?(directory_name)
      FileUtils.rm_r directory_name
    end
  end

  def run
    log = fetch_log

    all_hashes = log.each_line.map { |line| line.strip[0..6] }
    issue_hashes = all_hashes.take_while { |hash| hash != base_hash }.reverse

    issue_hashes.each do |issue_hash|
      client.create_issue(issuing_repo, issue_title(issue_hash), issue_body(issue_hash))
    end

    update_lastest_hash(issue_hashes.last)
  ensure
    delete_temp_repo
  end
end
