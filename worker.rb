#!/usr/bin/ruby-rvm-env 1.9.2@pro-tweets
#
# = Pro Tweets Background Worker Script
#

# Require gems from Gemfile
require 'rubygems'
require 'bundler'

Bundler.require :utility, :worker


class Worker < Thor

	include Thor::Actions

	desc 'fetch_tweets', 'Fetches tweets from the Twitter search API into the database'
	method_option :query, :type => :string, :default => "#protip", :required => false
	def fetch_tweets(number=50)
		load_config
		configure_twitter_client
		open_database
		tweets = Twitter.search(@config.twitter.search_query, :lang => 'en', :rpp => number)
		errors = []

		tweets.each do |tweet|
			existing = Tweet.first(:tweet_id => tweet.id.to_s)

			if existing
				say_status 'skip', 'Skipping existing tweet'
				next
			end

			new_tweet = Tweet.new(
				:created_at        => tweet.created_at,
				:tweet_id          => tweet.id.to_s,
				:from_user         => tweet.from_user,
				:from_user_name    => tweet.from_user_name,
				:from_user_id      => tweet.from_user_id.to_s,
				:profile_image_url => tweet.profile_image_url,
				:text              => tweet.text,
				:to_user           => tweet.to_user,
				:to_user_name      => tweet.to_user_name,
				:to_user_id        => tweet.to_user_id.to_s
			)

			if new_tweet.save
				say_status 'saved', "Tweet from @#{tweet.from_user}: #{tweet.text}", :green
			else
				say_status 'error', "Error saving tweet from @#{tweet.from_user}", :red
			end
		end
	end

	desc 'remove_old_tweets [AGE_IN_DAYS]', 'Deletes old tweets from the database'
	def remove_old_tweets(age=7)

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
			@config = Hashie::Mash.new(YAML.load_file(File.join(File.dirname(__FILE__), 'config', 'config.yml')))
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
			DataMapper::Logger.new(STDOUT, :info)
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
