class ChatUsersController < ApplicationController
  before_action :set_chat_user, only: %i[show edit update destroy]

  # GET /chat_users or /chat_users.json
  def index
    @chat_users = ChatUser.all
  end

  # GET /chat_users/1 or /chat_users/1.json
  def show
  end

  # GET /chat_users/new
  def new
    @chat_user = ChatUser.new
  end

  # GET /chat_users/1/edit
  def edit
  end

  # POST /chat_users or /chat_users.json
  def create
    @chat_user = ChatUser.new(chat_user_params)

    respond_to do |format|
      if @chat_user.save
        format.html { redirect_to @chat_user, notice: "User added to chat." }
        format.json { render :show, status: :created, location: @chat_user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chat_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chat_users/1 or /chat_users/1.json
  def update
    respond_to do |format|
      if @chat_user.update(chat_user_params)
        format.html { redirect_to @chat_user, notice: "Chat member updated." }
        format.json { render :show, status: :ok, location: @chat_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chat_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chat_users/1 or /chat_users/1.json
  def destroy
    @chat_user.destroy!

    respond_to do |format|
      format.html { redirect_to chat_users_path, status: :see_other, notice: "User removed from chat." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_chat_user
    @chat_user = ChatUser.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def chat_user_params
    params.expect(chat_user: [:chat_id, :user_id])
  end
end
