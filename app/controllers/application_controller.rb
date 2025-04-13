class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :set_current_user

  private

  def set_current_user
    @_current_user ||= User.find_by(id: cookies.signed[:user_id])

    if @_current_user.blank?
      @_current_user = User.create!

      cookies.signed[:user_id] = {
        value: @_current_user.id,
        expires: 20.years.from_now
      }
    end
  end

  def current_user
    @_current_user
  end
  helper_method :current_user
end
