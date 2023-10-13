class SearchController < ApplicationController
  def suggestions
    @results = search_results

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
            turbo_stream.update('suggestions',
                                partial: 'search/suggestions',
                                locals: { results: @results })
      end
    end
  end

  private

  def search_results
    User.where("first_name LIKE ? OR last_name LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%") +
    Post.where("title LIKE ? OR description LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%") + 
    Job.where("title LIKE ? OR description LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%") + 
    Event.where("event_name LIKE ? OR description LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
  end

end
