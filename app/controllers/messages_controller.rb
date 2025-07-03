class MessagesController < ApplicationController
  before_action :set_chat
  before_action :set_message, only: %i[show edit update destroy]

  # GET /chats/:chat_token/messages or /chats/:chat_token/messages.json
  def index
    @messages = @chat.messages
  end

  # GET /chats/:chat_token/messages/:id or /chats/:chat_token/messages/:id.json
  def show
  end

  # GET /chats/:chat_token/messages/new
  def new
    @message = @chat.messages.build
  end

  # GET /chats/:chat_token/messages/:id/edit
  def edit
    authorize @message

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # POST /chats/:chat_token/messages or /chats/:chat_token/messages.json
  def create
    @message = @chat.messages.build(message_params)
    @message.author = current_user
    @message.original_language = current_user.preferred_language

    respond_to do |format|
      if @message.save
        # Track message creation event
        ahoy.track "message_created", {
          chat_id: @chat.id,
          message_id: @message.id,
          original_language: @message.original_language.code,
          content_length: @message.content.length
        }

        @chat.users.excluding(current_user).each do |user|
          NewMessageNotifier.with(chat: @chat).deliver(user)
        end
        format.turbo_stream
        format.html { redirect_to chat_url(@message.chat) }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    authorize @message

    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to chat_url(@chat), notice: "Message updated." }
        format.json { render :show, status: :ok, location: chat_url(@chat) }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    authorize @message
    @message.destroy!

    respond_to do |format|
      format.html { redirect_to chat_url(@chat), status: :see_other, notice: "Message deleted." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_chat
    @chat = Chat.find_by!(token: params[:chat_token])
  end

  def set_message
    @message = @chat.messages.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def message_params
    params.require(:message).permit(:chat_id, :content)
  end
end
