class MessagePolicy
  attr_reader :user, :message

  def initialize(user, message)
    @user = user
    @message = message
  end

  def edit?
    message.author == user
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end
end
