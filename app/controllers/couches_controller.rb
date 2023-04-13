class CouchesController < ApplicationController
  def index
    @couches = Couch.includes(:reviews, user: [{ photo_attachment: :blob }, :characteristics]).where(active: true)
    @couches = @couches.search(params[:query]) if params[:query].present?
    find_couches_by_characteristics if params[:characteristics].present?

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

  def find_couches_by_characteristics
    @couches = @couches.joins(user: { user_characteristics: :characteristic })
                       .where(characteristics: { id: params[:characteristics] }).uniq
  end
end
