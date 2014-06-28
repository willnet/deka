require 'yaml'

class ReadmeTracker::Cli
  attr_accessor :yaml_path

  def self.run(config = {})
    new(config).run
  end

  def initialize(config)
    @yaml_path = config[:yaml_path] || './readme_tracker.yml'
  end

  def run
    yaml = YAML.load(File.read(yaml_path))
    system "git clone git@github.com:#{yaml['repo']}.git"
  end
end
