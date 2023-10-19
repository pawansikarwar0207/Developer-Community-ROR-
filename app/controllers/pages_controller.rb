class PagesController < ApplicationController
  before_action :set_page, only: %i[edit show update destroy]

  def index
    @pages = Page.includes(:user).order(created_at: :desc)  
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.create(pages_params)
    if @page.save
      redirect_to pages_path
    else
      render :new
    end
  end

  def edit
  end

  def show
  end

  def update
    if @page.update(pages_params)
      redirect_to pages_path
    else
      render :edit
    end
  end

  def destroy
    if @page.destroy
      redirect_to pages_path
    end
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def pages_params
    params.require(:page).permit(:title, :about, :industry, :website, :organization_size, :organization_type, :user_id, :content, :image)
  end

end
