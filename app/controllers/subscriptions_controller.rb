class SubscriptionsController < ApplicationController
  before_action :set_subscription, except: %i[new create]

  def new
    @plans = Plan.all
    @monthly = get_plans(@plans, 'month')
    @yearly = get_plans(@plans, 'year')
  end

  def show
    @subscription
  end

  def create
    @subscription = Subscription.new(subscription_params)

    if @subscription.save
      render 'subscription/show', status: :created
    else
      render 'subscription/new', status: :unprocessable_entity
    end
  end

  def update
    if @subscription.update(subscription_params)
      render 'subscription/show', status: :created
    else
      flash[:alert] = 'Something went wrong. Please try again or contact the Quouch Team.'
      render 'subscription/show', status: :unprocessable_entity
    end
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.require(:data).permit(:card_number, :exp_month, :exp_year, :cvc, :user_id, :plan_id, :active)
  end

  def get_plans(plans, interval)
    plans.where(interval:).order('id')
  end
end
