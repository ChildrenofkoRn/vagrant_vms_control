require 'open3'

module Runner
  def runner(params)
    stdout, s = Open3.capture2e(params)
    [stdout, s.success?]
  end

  def runner_pipe(params)
    # https://docs.ruby-lang.org/en/2.5.0/Open3.html#method-c-pipeline
    Open3.popen2e(params) do |_stdin, stdout, _wait_thr|
      while (line = stdout.gets)
        puts line.chomp
      end
    end
  end
end
