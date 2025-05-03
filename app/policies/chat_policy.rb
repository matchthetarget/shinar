class ChatPolicy
  attr_reader :user, :chat

  def initialize(user, chat)
    @user = user
    @chat = chat
  end

  def index?
    true
  end

  def show?
    true # Allow viewing any chat
  end

  def create?
    true # Any user can create a chat
  end

  def update?
    user == chat.creator
  end

  def destroy?
    user == chat.creator
  end

  def qr?
    true # Anyone can view the QR code
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      @scope.joins(:chat_users).where(chat_users: { user_id: @user.id })
    end

    private

    attr_reader :user, :scope
  end
end
