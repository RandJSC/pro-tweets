class Tweet
	include DataMapper::Resource

	property :id, Serial 
	property :created_at, DateTime, index: true
	property :from_user, String, length: 255, index: true
	property :from_user_id, String, length: 255
	property :from_user_name, String, length: 255
	property :tweet_id, String, length: 255, unique_index: true, unique: true
	property :profile_image_url, String, length: 255
	property :source, String, length: 255
	property :text, String, length: 255, required: true
	property :to_user, String, length: 255, index: true
	property :to_user_id, String, length: 255
	property :to_user_name, String, length: 255
end

# vim: set ft=ruby sw=2 ts=2 :
