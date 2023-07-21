class MembersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def update
  @user = User.find(params[:id])
  if @user.update(user_params)
    redirect_to root_path, notice: 'User was successfully updated.'
  else
    render :edit
  end
end


private

def user_params
  params.require(:user).permit(:first_name, :last_name, :date_of_birth, :about, :contact_number, :email, :username, :city, :state, :country, :pincode, :street_address, :profile_title)
end

end
