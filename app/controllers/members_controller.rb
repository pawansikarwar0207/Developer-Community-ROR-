class MembersController < ApplicationController

  def index
    @user = User.find(params[:id]) # Or whatever logic you use to find the user
    # Additional code and logic for the index action
  end
  
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

def fetch_country_states
  country = ISO3166::Country[params[:country_code]]
  @states = country.states.map { |state| [state.first, state[1].translations[I18n.locale.to_s]] }
end

def edit_description
  @user = User.find(params[:id])
end


private

def user_params
  params.require(:user).permit(:first_name, :last_name, :date_of_birth, :about, :contact_number, :email, :username, :city, :state, :country, :pincode, :street_address, :profile_title)
end

end
