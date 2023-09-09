class SharesController < ApplicationController

  def index
    @shared_posts = current_user.shared_posts # Implement this association in your User model
  end
  
  def new
    @share = Share.new
  end

  def create
    @share = Share.new(share_params)
    @share.sender = current_user

    if @share.save
      flash[:success] = "Post shared successfully!"
      redirect_to root_path
    else
      flash[:error] = "Error sharing post."
      render :new
    end
  end

  private

  def share_params
    params.require(:share).permit(:recipient_id, :post_id)
  end

end
