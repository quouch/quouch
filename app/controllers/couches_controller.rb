class CouchesController < ApplicationController
  def index
    @couches = Couch.includes(:reviews, user: [{ photo_attachment: :blob }, :characteristics])

    apply_search_filter if params[:query].present?
    apply_characteristics_filter if params[:characteristics].present?
    apply_offers_filter if params.keys.any? { |key| key.include?('offers') }

    respond_to do |format|
      format.html { redirect_to couches_path(@couches) }
      format.json
    end
  end

  def show
    @couch = Couch.find(params[:id])
    @host = User.find(@couch.user.id)
    @reviews = Review.where(couch_id: params[:id])
    @review_average = @reviews.average(:rating).to_f
    @chat = Chat.find_by(user_sender_id: @host.id, user_receiver_id: current_user.id) ||
            Chat.find_by(user_sender_id: current_user.id, user_receiver_id: @host.id)
  end

  private

  def apply_search_filter
    @couches = @couches.search(params[:query])
  end

  def apply_characteristics_filter
    @couches = @couches.joins(user: { user_characteristics: :characteristic })
                       .where(characteristics: { id: params[:characteristics] })
                       .group('couches.id')
                       .having('COUNT(DISTINCT characteristics.id) = ?', params[:characteristics].length)
  end

  def apply_offers_filter
    offers_conditions = {}

    offers_conditions[:offers_hang_out] = true if params[:offers_hang_out]
    offers_conditions[:offers_co_work] = true if params[:offers_co_work]
    offers_conditions[:offers_couch] = true if params[:offers_couch]

    @couches = @couches.joins(:user).where(user: offers_conditions) if offers_conditions.any?
  end
end
