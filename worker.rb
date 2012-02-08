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
		configure_twitter_client
		open_database
	end

	desc 'migrate_database', 'Run automatic migrations on database. DELETES ALL DATA'
	def migrate_database
		load_config
		open_database
		DataMapper.auto_migrate!
	end

	desc 'upgrade_database', 'Run automatic database upgrades. Does not alter data'
	def upgrade_database
		load_config
		open_database
		DataMapper.auto_upgrade!
	end

	private
		def load_config
			@config = Hashie::Mash.new(YAML.load_file(File.join(File.dirname(__FILE__), 'config.yml')))
		end

		def configure_twitter_client
			Twitter.configure do |config|
				config.consumer_key       = @config.twitter.consumer_key
				config.consumer_secret    = @config.twitter.consumer_secret
				config.oauth_token        = @config.twitter.oauth_token
				config.oauth_token_secret = @config.twitter.oauth_token_secret
			end
		end

		def open_database
			DataMapper::Logger.new(STDOUT, :debug)
			DataMapper.setup(:default, {
				adapter: 'sqlite',
				database: @config.database
			})
			Dir.glob(File.join(File.dirname(__FILE__), 'models', '*.rb')).each do |model|
				require model
			end
			DataMapper.finalize
		end
end

Worker.start



# vim: set ft=ruby ts=2 sw=2 :
