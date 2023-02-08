class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: :home

  def home
    @couches = Couch.all
  end

  def impressum
  end

  def about
  end

  def contact
  end
end
