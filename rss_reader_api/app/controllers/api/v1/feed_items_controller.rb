class Api::V1::FeedItemsController < ApplicationController
  def index
    page = params[:page].to_i
    page = 1 if page < 1

    per_page = params[:per_page].to_i
    per_page = 5 if per_page < 1
    per_page = 50 if per_page > 50

    scope = FeedItem.includes(:feed)
    scope = scope.where(feed_id: params[:feed_id]) if params[:feed_id].present?
    scope = scope.order(published_at: :desc, created_at: :desc)

    total = scope.count
    items = scope.offset((page - 1) * per_page).limit(per_page)

    render json: {
      items: items.as_json(only: [:id, :title, :url, :summary, :published_at, :read],
        include: { feed: { only: [:id, :title] } }),
      total: total, page: page, per_page: per_page
    }
  end

  def toggle_read
    item = FeedItem.find(params[:id])
    item.update!(read: !item.read)
    render json: { id: item.id, read: item.read }
  end
end
