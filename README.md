# s3up
====

Uploader service for automator. Uses Ruby and Automator workflows


## Installation

1) Step one:
Install ruby >2.0
Have the following gems:
```ruby
require 'aws-sdk'
require 'terminal-notifier'
```

2) Step two:
Create ~.s3up/config.yaml
An example is located in the src directory. This is what AWS creds/profile to use and the name of the bucket.

