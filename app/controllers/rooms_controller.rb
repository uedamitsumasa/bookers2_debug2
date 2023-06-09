class RoomsController < ApplicationController


  def create
    @room = Room.create
    # current_userのEntry
    @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
    # DMを受け取る側のEntry（users/showでuser_idは渡しているため、room_idを拾って、マージしている）
    @entry2 = Entry.create((entry_params).merge(room_id: @room.id))
    redirect_to room_path(@room)
  end

  def show
    @room = Room.find(params[:id])
    # entriesテーブルにcurrent_user.idと紐付いたチャットルームがあるかどうか確認
    if Entry.where(user_id: current_user.id,room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      # チャットルームのユーザ情報を表示させるため代入
      @entries = @room.entries
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private
    def entry_params
      params.require(:entry).permit(:user_id, :room_id)
    end
end
