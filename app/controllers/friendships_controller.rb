class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def show
    @friend = Friendship.find(params[:id]).friend
    @exercises = @friend.exercises.all
  end

  def create
    friend = User.find(params[:friend_id])
    head :conflict if current_user.follows_or_same?(friend)
    Friendship.create(friendship_params)
    redirect_to root_path
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    if @friendship.destroy
      flash[:success] = "#{@friendship.friend.full_name} unfollowed."
    else
      flash[:danger] = "#{@friendship.friend.full_name} could not be unfollowed."
    end

    redirect_to user_exercises_path(current_user)
  end

  private

  def friend_id
    params.require(:friend_id)
  end

  def friendship_params
    {friend_id: friend_id, user_id: current_user.id}
  end
end
