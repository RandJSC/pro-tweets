require "rubygems"
require "bundler"

Bundler.require :utility, :app

require File.join(File.dirname(__FILE__), 'application.rb')

set :root, File.dirname(__FILE__)
set :views, File.join(File.dirname(__FILE__), 'views')
run ProTweets
