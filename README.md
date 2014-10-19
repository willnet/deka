# ReadmeTracker

[![Build Status](https://travis-ci.org/willnet/readme_tracker.svg?branch=master)](https://travis-ci.org/willnet/readme_tracker)

ReadmeTracker provides `readme_tracker` command which track files (ex: README.md) and write github issues if new commits detected. It is useful to translate documents on github and keep them fresh.

### examples of use

- [willnet/capybara-readme-ja](https://github.com/willnet/capybara-readme-ja)

## Installation

Add this line to your application's Gemfile:

    gem 'readme_tracker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install readme_tracker

## Usage

* requirement: `git` command
* You should create a config file (ex: `./readme_tracker.yml`) and write settings.
* Use `readme_tracker` command to watch `watching_repo` and write issues to `issuing_repo`. If you don't want to watch all commits, write a commit hash to `.tracked_hash`, readme_tracker doesn't write issues prior to the commit hash.
* `.tracked_hash` if automatically updated by `readme_tracker` command

```
Usage: readme_tracker [options]
        --dry-run      Dry run
    -c, --config       config path (default `./readme_tracker.yml`)
    -s, --save         path for saving tracked hash (default `./.tracked_hash`)
```

### config file example

```
watching_files: 'README.md'
watching_repo: 'willnet/readme_tracker_watching_repo'
issuing_repo: 'willnet/readme_tracker_issuing_repo'
body: 'please respond'
access_token: YOUR_GITHUB_ACCESS_TOKEN
```

## Contributing

1. Fork it ( https://github.com/willnet/readme_tracker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
