# ReadmeTracker

[![Build Status](https://travis-ci.org/willnet/readme_tracker.svg?branch=master)](https://travis-ci.org/willnet/readme_tracker)

ReadmeTracker provides `readme_tracker` command which track README.md and write github issues if new commits detected.

## Installation

Add this line to your application's Gemfile:

    gem 'readme_tracker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install readme_tracker

## Usage

* requirement: git command
* You should create `./readme_tracker.yml` and write settings.

example

```
watching_repo: 'willnet/readme_tracker_watching_repo'
issuing_repo: 'willnet/readme_tracker_issuing_repo'
body: 'please respond'
access_token: 'YOUR_GITHUB_ACCESS_TOKEN'
```

## Contributing

1. Fork it ( https://github.com/willnet/readme_tracker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
