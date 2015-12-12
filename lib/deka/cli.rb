require 'yaml'
require 'fileutils'
require 'octokit'

module Deka
  class Cli
    attr_accessor :config, :base_hash, :yaml, :save_file

    def self.run(options = {})
      new(options).run
    end

    def initialize(options = {})
      @config = options[:config] || './deka.yml'
      @save_file = options[:save] || './.tracked_hash'
      @base_hash = File.exist?(save_file) && File.read(save_file).chomp
      @dry_run = options[:'dry-run']
    end

    def run
      log = fetch_log

      all_hashes = log.each_line.map { |line| line.strip[0..39] }
      issue_hashes = all_hashes.take_while { |hash| hash != base_hash }.reverse

      issue_hashes.each do |issue_hash|
        create_issue(issuing_repo, issue_hash)
      end

      update_lastest_hash(issue_hashes.last)
    ensure
      delete_temp_repo
    end

    def client
      @client ||= Octokit::Client.new(access_token: access_token)
    end

    private

    def yaml
      return @yaml if @yaml

      unless File.exist?(config)
        puts "You don't have config file(default './deka.yml')"
        exit 1
      end

      @yaml = YAML.load(File.read(config))
    end

    def watching_files
      yaml['watching_files'] || 'README.md'
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

    def issue_title(issue_hash)
      "about #{issue_hash[0..6]}"
    end

    def issue_body(issue_hash)
      commit_url = "https://github.com/#{watching_repo}/commit/#{issue_hash}"
      if yaml['body']
        yaml['body'] + "\n\n#{commit_url}"
      else
        "please respond \n\n#{commit_url}"
      end
    end

    def fetch_log
      system "git clone https://github.com/#{watching_repo}.git"
      log = ''
      FileUtils.cd directory_name do
        log = `git log --pretty=oneline #{watching_files}`
      end
      log
    end

    def create_issue(repo, hash)
      title = issue_title(hash)
      body = issue_body(hash)
      client.create_issue(repo, title, body) unless @dry_run
      puts "created issue of #{hash}"
    end

    def update_lastest_hash(latest_hash)
      unless @dry_run
        File.open(save_file, 'w') do |file|
          file.write(latest_hash)
        end
      end
      puts "updated #{save_file} with #{latest_hash}"
    end

    def delete_temp_repo
      return unless File.exist?(directory_name)
      FileUtils.rm_r directory_name
    end
  end
end
