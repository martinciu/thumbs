env = "production"
app_root = File.expand_path("../..", __FILE__)

%w{9001 9002}.each do |port|
  God.watch do |w|
    w.name = "thumbs-#{env}-#{port}"
    w.group = "thumbs-#{env}"
    w.interval = 30.seconds
    w.dir = app_root
    w.start = "thumbs -p #{port} -e #{env}"
    w.uid = 'rails'
    w.gid = 'rails'
    
    w.stop_signal = 'QUIT'
    w.stop_timeout = 20.seconds

    # restart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 150.megabytes
        c.times = 2
      end
    end

    # determine the state on startup
    w.transition(:init, { true => :up, false => :start }) do |on|
      on.condition(:process_running) do |c|
        c.running = true
      end
    end

    # determine when process has finished starting
    w.transition([:start, :restart], :up) do |on|
      on.condition(:process_running) do |c|
        c.running = true
        c.interval = 5.seconds
      end

      # failsafe
      on.condition(:tries) do |c|
        c.times = 5
        c.transition = :start
        c.interval = 5.seconds
      end
    end

    # start if process is not running
    w.transition(:up, :start) do |on|
      on.condition(:process_running) do |c|
        c.running = false
      end
    end
  end
end
