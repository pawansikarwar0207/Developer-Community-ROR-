class SearchController < ApplicationController

  def suggestions
    @results = search_for_posts

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

  def search_for_posts
      Post.where("title LIKE ? OR description LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
  end

end
