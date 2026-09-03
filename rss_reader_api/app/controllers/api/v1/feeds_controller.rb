class Api::V1::FeedsController < ApplicationController
  def index
    render json: Feed.order(created_at: :desc).select(:id, :title, :url, :last_fetched_at)
  end

  def create
    feed = Feed.new(feed_params)
    if feed.save
      Feeds::FetchService.call(feed)

      render json: feed.as_json(only: [:id, :title, :url, :last_fetched_at]), status: :created
    else
      render json: { errors: feed.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    Feed.find(params[:id]).destroy!
    head :no_content
  end

  private

  def feed_params
    params.require(:feed).permit(:title, :url)
  end
end
