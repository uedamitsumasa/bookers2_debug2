class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update,:edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @currentUserEntry = Entry.where(user_id: current_user.id).all
    @userEntry = Entry.where(user_id: @user.id).all
    if @user.id != current_user.id
      # currentUserと@userのEntriesをそれぞれ一つずつ取り出し、2人のroomが既に存在するかを確認
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          # 2人のroomが既に存在していた場合
          if cu.room_id == u.room_id
            @isRoom = true
            #room_idを取り出す
            @roomId = cu.room_id
          end
        end
        end

  # 2人ののroomが存在しない場合
      unless @isRoom
        #roomとentryを新規に作成する
        @room = Room.new
        @entry = Entry.new
      end
    end
  end





  def index
    @users = User.all
    @book = Book.new
  end

  def edit
     @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
