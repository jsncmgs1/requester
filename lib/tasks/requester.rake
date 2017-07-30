desc 'Runs your specs and generates a JSON file based on the selected specs'

task :requester do
  ENV['REQUESTER'] = 'true'

  command = defined?(RSpec) ? 'rspec' : 'rails test'

  command += " #{ARGV[1..-1].join(' ')}"

  puts(<<-COMMAND)
    \n *********************************************************
    \n Running requester using command: #{command.rstrip}
    \n *********************************************************
    \n
  COMMAND

  system(command)

  ENV['REQUESTER'] = nil
end
