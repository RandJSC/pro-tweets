require "rubygems"
require "bundler"

# = Require Dependencies
Bundler.require :utility, :app
require File.join(File.dirname(__FILE__), 'application.rb')

# = Application Settings
set :root, File.dirname(__FILE__)
set :views, File.join(settings.root, 'views')
set :public_directory, File.join(settings.root, 'public')
set :environment, :production
enable :logging
enable :dump_errors

# = Execute the Application
run ProTweets
