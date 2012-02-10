# Unicorn Configuration File

pid File.join(File.dirname(__FILE__), '..', 'tmp', 'unicorn.pid')
worker_processes 2

listen "/tmp/pro_tweets.sock", :backlog => 64

after_fork do |server,worker|
	server.listen("localhost:#{9293 + worker.nr}")
end
