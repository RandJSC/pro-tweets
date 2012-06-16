require "rubygems"
require "sinatra"
require "twitter"
require "hashie"
require "haml"
require "coffee-script"
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

    Dir.glob(File.join(settings.root, 'models', '*.rb')).each do |model|
      require model
    end

    # Commit models. Migrations get run from the worker script.
    DataMapper.finalize
  end

  helpers do
    # Get bigger user icons w/o using API requests
    def bigger_image(url)
      url.gsub!(/normal/, 'bigger')
    end
  end

  get "/" do
    haml :index
  end

  get '/tweets.json' do
    tpp = 200
    @page = params[:page].to_i if params[:page]

    if @page
      @tweets = Tweet.all(:order => [:created_at.desc], :limit => tpp, :offset => (tpp*params[:page].to_i))
    else
      @tweets = Tweet.all(:order => [:created_at.desc], :limit => tpp)
    end

    content_type 'application/json'
    @tweets.to_json
  end

  [ "/tweets/:id.:format", "/tweets/:id" ].each do |path|
    get path do
      @tweet = Tweet.first(:tweet_id => params[:id])
      @format = params[:format] || "html"

      cache_control 86400
      last_modified @tweet.created_at

      if @format == "json"
        content_type 'application/json'
        @tweet.to_json
      else
        haml :tweet
      end
    end
  end

  get "/ping" do
    "PONG"
  end

  get "/rate_limit" do
    rls = Twitter.rate_limit_status
    content_type 'application/json'
    rls.attrs.to_json
  end

  get "/stylesheets/:sheet.css" do
    lastmod = File.mtime(File.join(settings.views, "stylesheets", "#{params[:sheet]}.scss"))
    cache_control 86400 # Cache locally 24 hours
    last_modified lastmod
    content_type 'text/css'
    scss "stylesheets/#{params[:sheet]}".to_sym
  end

  get '/coffeescripts/:script.js' do
    lastmod = File.mtime(File.join(settings.views, "coffeescripts", "#{params[:script]}.coffee"))
    #cache_control 86400
    last_modified lastmod
    content_type 'text/javascript'
    coffee "coffeescripts/#{params[:script]}".to_sym
  end

  private
    def cache_control(seconds)
      headers 'Cache-Control' => "public,must-revalidate,max-age=#{seconds}"
    end

end

# vim: set ft=ruby ts=2 sw=2 expandtab :
