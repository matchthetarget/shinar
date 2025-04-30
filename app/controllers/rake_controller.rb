class RakeController < ApplicationController
  require "rake"
  Rails.application.load_tasks

  def db_seed
    # Re-enable the task if it has already been executed
    Rake::Task["db:seed"].reenable
        
    # Run the rake task
    Rake::Task["db:seed"].invoke
    redirect_to "/"
  end
end
