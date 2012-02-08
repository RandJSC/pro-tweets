#!/usr/bin/env ruby
#
# = Pro Tweets Background Worker Script
#

# Require gems from Gemfile
require 'rubygems'
require 'bundler'

Bundler.require :utility, :worker

class Worker < Thor

	desc 'fetch_tweets', 'Fetches tweets from the Twitter search API into the database'
	method_option :query, :type => :string, :default => "#protip", :required => false
	def fetch_tweets
		load_config
	end

	private
		def load_config
			@config = Hashie::Mash.new(YAML.load_file(File.join(File.dirname(__FILE__), 'config.yml')))
		end
end

Worker.start



# vim: set ft=ruby ts=2 sw=2 :
