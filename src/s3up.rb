#!/usr/bin/env ruby

require 'rubygems'
require 'aws-sdk'
require 'yaml'
require 'terminal-notifier'

AWS.config(YAML.load_file(File.expand_path("~/.aws/awsconfig.yaml")))
s3 = AWS::S3.new

bucket_name = 'www.chadneal.com'
file_name = ARGV[0]
key_name = File.basename(file_name)
url = 'http://' << bucket_name << '/' << key_name

def pbcopy(input)
  str = input.to_s
  IO.popen('pbcopy', 'w') { |f| f << str }
  str
end

def pbpaste
  `pbpaste`
end

bucket = s3.buckets[bucket_name]
obj = bucket.objects[key_name].write(:file => file_name)

pbcopy(url)
TerminalNotifier.notify("File is now available @ " << url)
