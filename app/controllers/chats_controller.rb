class ChatsController < ApplicationController
  before_action :set_chat, only: %i[ show edit update destroy qrcode ]

  # GET /chats or /chats.json
  def index
    @chats = Chat.order(updated_at: :desc)
  end

  # GET /chats/1 or /chats/1.json
  def show
  end

  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # GET /chats/1/edit
  def edit
  end

  # POST /chats or /chats.json
  def create
    @chat = Chat.new(creator: current_user)

    respond_to do |format|
      if @chat.save
        format.html { redirect_to @chat, notice: "New chat created!" }
        format.json { render :show, status: :created, location: @chat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chats/1 or /chats/1.json
  def update
    respond_to do |format|
      if @chat.update(chat_params)
        format.html { redirect_to @chat, notice: "Chat updated." }
        format.json { render :show, status: :ok, location: @chat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1 or /chats/1.json
  def destroy
    @chat.destroy!

    respond_to do |format|
      format.html { redirect_to chats_path, status: :see_other, notice: "Chat deleted." }
      format.json { head :no_content }
    end
  end

  # GET /chats/:token/qrcode
  def qrcode
    require "rqrcode"

    chat_url = url_for(@chat)
    @qr = RQRCode::QRCode.new(chat_url)

    respond_to do |format|
      format.html
      format.svg { render inline: @qr.as_svg(viewbox: true) }
      format.png do
        send_data @qr.as_png(size: 300).to_s, type: "image/png", disposition: "inline"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find_by!(token: params[:token])
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:subject)
    end
end
