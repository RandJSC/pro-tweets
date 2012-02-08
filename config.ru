require "rubygems"
require "bundler"

Bundler.require :utility, :app

require File.join(File.dirname(__FILE__), 'application.rb')
run ProTweets
