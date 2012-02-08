#!/usr/bin/env ruby
#
# = Pro Tweets Background Worker Script
#

# Require gems from Gemfile
require 'rubygems'
require 'bundler'

Bundler.require

Config = Hashie::Mash.new(YAML.load_file(File.join(File.dirname(__FILE__), 'config.yml')))
scheduler = Rufus::Scheduler.start_new

scheduler.cron "*/1 * * * *" do
	puts "Hello!"
end

# vim: set ft=ruby ts=2 sw=2 :
