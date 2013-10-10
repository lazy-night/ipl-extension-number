@dir = File.expand_path(File.join(File.dirname(__FILE__)), '.')

worker_processes 2
working_directory "#{@dir}"

listen "#{@dir}/tmp/sockets/unicorn.sock", :backlog => 64
pid "#{@dir}/tmp/pids/unicorn.pid"

stderr_path "#{@dir}/log/unicorn.stderr.log"
stdout_path "#{@dir}/log/unicorn.stdout.log"
