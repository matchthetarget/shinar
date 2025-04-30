class RakeController < ApplicationController
  require "rake"
  Rails.application.load_tasks
  skip_before_action :set_current_user
  skip_around_action :set_time_zone

  def db_seed
    # Re-enable the task if it has already been executed
    Rake::Task["db:seed"].reenable

    # Run the rake task
    Rake::Task["db:seed"].invoke
    redirect_to "/"
  end
end
