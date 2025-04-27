class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :store_location, only: [ :edit ]
  before_action :authorize_user, only: [ :edit, :update, :destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "Account created successfully!" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        if request.referrer&.include?(edit_user_path(@user))
          # Coming from edit page, use stored location
          redirect_path = session[:return_to] || root_path
        else
          # Coming from elsewhere (like language dropdown), redirect back to referrer
          redirect_path = request.referrer || root_path
        end

        # Clear stored location
        session.delete(:return_to)

        format.html { redirect_to redirect_path, notice: "Your profile has been updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to root_path, status: :see_other, notice: "Account deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.expect(user: [ :name, :preferred_language_id ])
    end

    def authorize_user
      authorize @user
    end

    def store_location
      # Store the HTTP_REFERER for redirect after update
      if request.referer && !request.referer.include?(edit_user_path(@user))
        session[:return_to] = request.referer
      end
    end
end
