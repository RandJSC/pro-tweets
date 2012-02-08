class Tweet
	include DataMapper::Resource

	property :id, Serial 
	property :created_at, DateTime
	property :from_user, String, length: 255
	property :from_user_id, String, length: 255
	property :from_user_name, String, length: 255
	property :tweet_id, String, length: 255
	property :profile_image_url, String, length: 255
	property :source, String, length: 255
	property :text, String, length: 255
	property :to_user, String, length: 255
	property :to_user_id, String, length: 255
	property :to_user_name, String, length: 255
end

# vim: set ft=ruby sw=2 ts=2 :
