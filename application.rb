require "rubygems"
require "sinatra"
require "twitter"
require "hashie"
require "yaml"

class ProTweets < Sinatra::Application

	configure do
		Config = Hashie::Mash.new(YAML.load_file(File.join(File.dirname(__FILE__), 'config.yml')))
	end

	get "/" do
		"Ahoyhoy"
	end

	get "/ping" do
		"PONG"
	end
end

# vim: set ft=ruby ts=2 sw=2 :
