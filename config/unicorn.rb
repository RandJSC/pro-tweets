# Unicorn Configuration File

pid File.join(File.dirname(__FILE__), '..', 'tmp', 'unicorn.pid')

# Logging
log_path = File.join(File.dirname(__FILE__), '..', 'log')
stderr_path File.join(log_path, 'unicorn.stderr.log')
stdout_path File.join(log_path, 'unicorn.stdout.log')

# Number of workers
worker_processes 2

# Listen on UNIX socket
listen "/tmp/pro_tweets.sock", :backlog => 64

after_fork do |server,worker|
	server.listen("localhost:#{9293 + worker.nr}")
end
