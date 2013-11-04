#!/usr/bin/env ruby

require 'rubygems'
require 'aws-sdk'
require 'yaml'
require 'terminal-notifier'

AWS.config(YAML.load_file(File.expand_path("~/.aws/awsconfig.yaml")))
$s3 = AWS::S3.new

def upload(file_name)
  bucket_name = 'www.chadneal.com'
  key_name = File.basename(file_name)
  url = 'http://' << bucket_name << '/' << key_name
  
  bucket = $s3.buckets[bucket_name]
  bucket.objects[key_name].write(:file => file_name)
  
  pbcopy(url)
  TerminalNotifier.notify("File is now available @ " << url)
end

def pbcopy(input)
  str = input.to_s
  IO.popen('pbcopy', 'w') { |f| f << str }
  str
end

def pbpaste
  `pbpaste`
end

ARGV.each do |f|
  puts f
  if File.file?(f)
    upload(f)
  else
    TerminalNotifier.notify("s3up will not upload directory " << f)
  end
end
