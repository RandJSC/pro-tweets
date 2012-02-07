require "rubygems"
require "sinatra"
require "twitter"
require "hashie"
require "yaml"

class ProTweets < Sinatra::Application

  configure do
    Config = Hashie::Mash.new(YAML.load_file(File.join(File.dirname(__FILE__), 'config.yml')))

    Twitter.configure do |conf|
      conf.consumer_key       = Config.twitter.consumer_key
      conf.consumer_secret    = Config.twitter.consumer_secret
      conf.oauth_token        = Config.twitter.oauth_token
      conf.oauth_token_secret = Config.twitter.oauth_token_secret
    end
  end

  get "/" do
    content_type 'text/plain'
    @tips = Twitter.search("#protip")
    @tips.shuffle.first.attrs['text']
  end

  get "/ping" do
    "PONG"
  end
end

# vim: set ft=ruby ts=2 sw=2 expandtab :
