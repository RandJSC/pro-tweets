window.App = Em.Application.create
	ready: ->
		App.tweetsController.loadTweets()
		App.myName = "Mike"
###
# Routing
###

###
# Models
###
App.Tweet = Em.Object.extend
	id: null
	created_at: null
	from_user: null
	from_user_id: null
	from_user_name: null
	to_user: null
	to_user_id: null
	to_user_name: null
	tweet_id: null
	profile_image_url: null
	source: null
	text: null
	bigger_image_url: (->
		@.get('profile_image_url').replace(/normal/, 'bigger')
	).property()

###
# Controllers
###
App.tweetsController = Em.ArrayController.create
	content: []
	loadTweets: (callback) ->
		me = this
		$.getJSON '/tweets.json', (data) ->
			data.forEach (twt) ->
				tweet = App.Tweet.create(twt)
				me.pushObject tweet
			callback.apply(this) if arguments.length == 1

###
# Views
###
App.TweetView = Em.View.extend
	templateName: 'tweet'
	text: null

myTweetView = App.TweetView.create
	text: "Hello"
