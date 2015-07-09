#!/usr/bin/env ruby

require 'rubygems'
require 'aws-sdk'
require 'yaml'
require 'terminal-notifier'

def upload(file_name)

  config = YAML.load_file(File.expand_path('~/.s3up/config.yaml'))
  Aws.config.update({
                        region: 'us-east-1',
                        credentials: Aws::SharedCredentials.new(profile_name: config[0]['profile'])
  })
  s3 = Aws::S3::Resource.new
  bucket_name = config[0]['bucket']
  key_name = File.basename(file_name)
  url = 'http://' << bucket_name << '/' << key_name

  obj = s3.bucket(bucket_name).object(key_name).upload_file(file_name)

  pbcopy(url)
  TerminalNotifier.notify('File is now available @ ' << url)
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
    `say upload complete`
  else
    TerminalNotifier.notify('s3up will not upload directory ' << f)
  end
end
