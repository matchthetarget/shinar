class ApplicationController < ActionController::Base
  include Pundit::Authorization

  allow_browser versions: :modern if Rails.env.production?

  before_action :set_current_user
  around_action :set_time_zone, if: :current_user
  after_action :track_action

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_current_user
    @_current_user ||= User.find_by(id: cookies.signed[:user_id])

    if @_current_user.blank?
      # Use default timezone (Central Time)
      @_current_user = User.create!

      cookies.signed[:user_id] = {
        value: @_current_user.id,
        expires: 20.years.from_now
      }

      flash.now[:notice] = "Signed in as #{@_current_user.name}."
    end

    # Set current user for Ahoy tracking
    Current.user = @_current_user
  end

  def set_time_zone(&block)
    # Set Time.zone based on the user's timezone
    Time.use_zone(current_user.timezone, &block)
  end

  def current_user
    @_current_user
  end
  helper_method :current_user

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path, status: :see_other)
  end

  def track_action
    ahoy.track "#{controller_name}##{action_name}", request.filtered_parameters
  end
end
