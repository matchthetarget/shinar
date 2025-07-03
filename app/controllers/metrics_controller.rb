class MetricsController < ApplicationController
  before_action :authenticate_admin!

  def index
    # Visit metrics
    @total_visits = Ahoy::Visit.count
    @unique_visitors = Ahoy::Visit.distinct.count(:visitor_token)
    @visits_today = Ahoy::Visit.where("started_at >= ?", Time.current.beginning_of_day).count

    # Event metrics
    @total_events = Ahoy::Event.count
    @events_by_name = Ahoy::Event.group(:name).count

    # Chat metrics
    @total_chats = Chat.count
    @chats_created_today = Chat.where("created_at >= ?", Time.current.beginning_of_day).count
    @active_chats = Chat.joins(:messages).where("messages.created_at >= ?", 7.days.ago).distinct.count

    # Message metrics
    @total_messages = Message.count
    @messages_today = Message.where("created_at >= ?", Time.current.beginning_of_day).count
    @messages_by_day = Message.group_by_day(:created_at, last: 30).count

    # Translation metrics
    @total_translations = Translation.count
    @translations_today = Ahoy::Event.where(name: "translation_created")
                                     .where("time >= ?", Time.current.beginning_of_day)
                                     .count
    @translations_by_language = Translation.joins(:language)
                                          .group("languages.name")
                                          .count

    # User metrics
    @total_users = User.count
    @active_users = User.joins(:messages).where("messages.created_at >= ?", 7.days.ago).distinct.count
    @users_by_language = User.joins(:preferred_language)
                             .group("languages.name")
                             .count
  end
end
