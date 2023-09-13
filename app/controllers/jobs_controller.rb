class JobsController < ApplicationController

  before_action :set_jobs, only: %i[edit show update destroy]

  def index
    @jobs = Job.includes(:job_category).order(created_at: :desc)
  end

  def new
    @job = Job.new
  end

  def create
    @job = current_user.jobs.build(job_params)
    if @job.save
      redirect_to jobs_path
    end
  end


  def edit
    
  end

  def show
    
  end

  def update
    if @job.update(job_params)
      redirect_to jobs_path
    else
      render :edit
    end
  end

  def destroy
    if @job.destroy
      redirect_to jobs_path
    end
  end

  private

  def set_jobs
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:title, :employee_type, :location, :salary, :description, :qualification, :status, :job_category_id)
  end

end
