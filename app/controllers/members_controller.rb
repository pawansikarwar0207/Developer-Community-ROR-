class MembersController < ApplicationController

  def index
    @user = User.find(params[:id])
    @user = User.includes(:comments, :notifications, :posts, :connections, :work_experiences, :likes)
  end

  def show
    @user = User.find(params[:id])
    @connections = Connection.where('user_id = ? OR connected_user_id = ?', params[:id], params[:id]).where(status: 'accepted')
    @mutual_connections = current_user.mutually_connected_ids(@user)
  end

  def edit
    @user = User.find(params[:id])
    respond_to do |format|
      format.js
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

  def edit_personal_details

  end

  def update_personal_details
    if current_user.update(user_params)
      render_turbo_stream(
        'replace',
        'member_personal_details',
        'members/member_personal_details',
        { user: current_user }
        )
    end
  end

   def fetch_country_states
    country = ISO3166::Country[params[:country_code]]
    @states = country.states.map { |state| [state.first, state[1].translations[I18n.locale.to_s]] }    
   end

  def edit_description
  end

  def update_description
    if current_user.update(about: params[:user][:about] )
      render_turbo_stream(
        'replace',
        'member-description',
        'members/member_description',
         { user: current_user }
        )
    end
  end

  def connections
    @user = User.find(params[:id])
    total_users = if params[:mutual_connections].present?
                          User.where(id: current_user.mutually_connected_ids(@user))
                        else
                          User.where(id: @user.connected_user_ids)
                        end
    @connected_users = total_users.page(params[:page]).per(10)
    @total_connections = total_users.count
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :date_of_birth, :about, :contact_number, :email, :username, :city, :state, :country, :pincode, :street_address, :profile_title)
  end
end


