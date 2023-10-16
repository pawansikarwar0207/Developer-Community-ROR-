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

  def results
    @user = User.find(params[:user_id])
    @posts = Post.where(user_id: @user.id)
    @mutual_connections = current_user.mutually_connected_ids(@user)
    @post_likes_count = Post.joins(:likes).group('posts.id').count
    comment_counts = Comment.where(commentable_id: @posts.map(&:id), 
                     commentable_type: 'Post')
                     .group(:commentable_id)
                     .count

    # Now, you can create a hash where keys are post IDs and values are comment counts
    @post_comment_counts = comment_counts.transform_keys(&:to_i)
    @people_i_follow_count = @user.following.count # Set the count of followings here
  end

  private

  def search_results
    User.where("first_name LIKE ? OR last_name LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%") +
    Post.where("title LIKE ? OR description LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%") + 
    Job.where("title LIKE ? OR description LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%") + 
    Event.where("event_name LIKE ? OR description LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
  end

end
