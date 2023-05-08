class SubscriptionsController < ApplicationController
  before_action :set_subscription, except: %i[new create payment destroy]

  def new
    @plans = Plan.all
    @monthly = get_plans(@plans, 'month')
    @yearly = get_plans(@plans, 'year')
  end

  def show
    @plans = Plan.all
    @monthly = get_plans(@plans, 'month')
    @yearly = get_plans(@plans, 'year')
    @plan = current_user.subscription.plan
  end

  def create
    @subscription = Subscription.new(subscription_params)
    @plan = Plan.find(plan_id)

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

  def payment
    subscription_id = SecureRandom.uuid
    plan_id = params[:plan_id]
    @subscription = Subscription.new(id: subscription_id, plan_id:, user_id: current_user.id)

    checkout_session = Stripe::Checkout::Session.create({
      customer_email: current_user.email,
      payment_method_types: ['card'],
      line_items: [{
        price: @subscription.plan.stripe_price_id,
        quantity: 1
      }],
      mode: 'subscription',
      success_url: subscription_url(@subscription),
      cancel_url: new_subscription_url
    })

    @subscription.checkout_session_id = checkout_session.id
    @subscription.save!
    redirect_to checkout_session.url, allow_other_host: true
  end

  def destroy
    # remove subscription from stripe
    @subscription.destroy
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.require(:data).permit(:user_id, :plan_id, :active)
  end

  def get_plans(plans, interval)
    plans.where(interval:).order('id')
  end
end
