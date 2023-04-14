class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home]

  def home
    @couches = Couch.where.not(user: current_user)
    @active_couches = @couches.includes(:reviews, user: [{ photo_attachment: :blob }, :characteristics])
                              .uniq.select { |couch| couch.active == true }
  end
end
