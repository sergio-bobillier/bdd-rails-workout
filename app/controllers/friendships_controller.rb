class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    friend = User.find(params[:friend_id])
    head :conflict if current_user.follows_or_same?(friend)
    Friendship.create(friendship_params)
    redirect_to root_path
  end

  private

  def friend_id
    params.require(:friend_id)
  end

  def friendship_params
    {friend_id: friend_id, user_id: current_user.id}
  end
end
