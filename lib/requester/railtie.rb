module Requester
  class Railtie < Rails::Railtie
    railtie_name :requester
    rake_tasks do
      load 'tasks/requester.rake'
    end
  end
end
