require "rubygems"
require "sinatra"
require "twitter"
require "hashie"
require "yaml"

class ProTweets < Sinatra::Application

  configure do
    @config = Hashie::Mash.new(YAML.load_file(File.join(File.dirname(__FILE__), 'config', 'config.yml')))

    Twitter.configure do |conf|
      conf.consumer_key       = @config.twitter.consumer_key
      conf.consumer_secret    = @config.twitter.consumer_secret
      conf.oauth_token        = @config.twitter.oauth_token
      conf.oauth_token_secret = @config.twitter.oauth_token_secret
    end

    # Setup DataMapper and Require Models
    DataMapper::Logger.new($stdout, :info)
    DataMapper.setup(:default, {
      adapter: 'sqlite',
      database: @config.database
    })

    Dir.glob(File.join(File.dirname(__FILE__), 'models', '*.rb')).each do |model|
      require model
    end

    # Commit models. Migrations get run from the worker script.
    DataMapper.finalize
  end

  get "/" do
    @page = params[:page].to_i if params[:page]

    if @page
      @tweets = Tweet.all(:order => [:created_at.desc], :limit => 50, :offset => (50*params[:page].to_i))
    else
      @tweets = Tweet.all(:order => [:created_at.desc], :limit => 50)
    end

    haml :index
  end

  get "/tweets/:id.json" do
    @tweet = Tweet.find(:tweet_id => params[:id])
    
    content_type 'application/json'
    @tweet.to_json
  end

  get "/ping" do
    "PONG"
  end

  get "/rate_limit" do
    rls = Twitter.rate_limit_status
    content_type 'application/json'
    rls.attrs.to_json
  end
end

# vim: set ft=ruby ts=2 sw=2 expandtab :
