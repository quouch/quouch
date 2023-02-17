class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: :home

  def home
    @couches = Couch.where.not(user: current_user)
    @active_couches = @couches.uniq.select { |couch| couch.active == true }
  end

  def impressum
  end

  def about
  end

  def contact
  end
end
