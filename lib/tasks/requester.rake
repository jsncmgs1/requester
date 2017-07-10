desc 'Runs your specs and generates a JSON file based on the selected specs'

task :requester do
  ENV['REQUESTER'] = 'true'

  command = case Requester::Config.library
            when :rspec then 'rspec'
            else 'test'
            end

  command += " #{ARGV[1..-1].join(' ')}"

  puts(<<-COMMAND)
      \n *********************************************************
      \n Running requester using #{Requester::Config.library}
      \n Command: "#{command.rstrip}"
      \n *********************************************************
      \n
  COMMAND

  system(command)
  ENV['REQUESTER'] = nil
end
