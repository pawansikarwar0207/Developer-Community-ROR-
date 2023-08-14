class MembersController < ApplicationController
  before_action :authenticate_user!, only: %i[edit_description update_description edit_personal_details update_personal_details ]

  def index
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
    @connections = Connection.where('user_id = ? OR connected_user_id = ?', params[:id], params[:id]).where(status: 'accepted')
    @mutul_connections = current_user.mutually_connected_ids(@user)
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
    respond_to do |format|
      if current_user.update(user_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace('member_personal_details', partial: 'members/member_personal_details', locals: { user: current_user })  }
      end
    end
  end

  # def fetch_country_states
  #   country = ISO3166::Country[params[:country_code]]
  #   @states = country.states.map { |state| [state.first, state[1].translations[I18n.locale.to_s]] }
  # end

  def edit_description
  end

  def update_description
    respond_to do |format|
      if current_user.update(about: params[:user][:about] )
        format.turbo_stream { render turbo_stream: turbo_stream.replace('member-description', partial: 'members/member_description', locals: { user: current_user })  }
      end
    end
  end


  def connections
    @user = User.find(params[:id])
    @connected_users = if params[:mutul_connections].present?
                          mutually_connected_ids = current_user.mutually_connected_ids(@user)
                          User.where(id: mutually_connected_ids)
                        else
                          User.where(id: @user.connected_user_ids)
                        end
    @total_connections = @connected_users.count
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :date_of_birth, :about, :contact_number, :email, :username, :city, :state, :country, :pincode, :street_address, :profile_title)
  end
end


