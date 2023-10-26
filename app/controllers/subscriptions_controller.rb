class SubscriptionsController < ApplicationController
  before_action :set_subscription, except: %i[new payment]

  def new
    display_plans
  end

  def show
    display_plans
    @plan = current_user.subscription.plan
  end

  def payment
    @subscription = current_user.subscription
    if @subscription
      plan_id = params[:plan_id]
      @subscription.update(id: @subscription.id, plan_id:, user_id: current_user.id, active: true)
    else
      subscription_id = SecureRandom.uuid
      plan_id = params[:plan_id]
      @subscription = Subscription.new(id: subscription_id, plan_id:, user_id: current_user.id)
    end

    @checkout_session = create_checkout_session(@subscription)
    @subscription.checkout_session_id = @checkout_session.id
    @subscription.save!
    redirect_to @checkout_session.url, allow_other_host: true
  end

  def destroy
    session = Stripe::Checkout::Session.retrieve(@subscription.checkout_session_id)
    @subscription.update(stripe_id: session.subscription)
    Stripe::Subscription.cancel(@subscription.stripe_id)
    if Subscription.find(@subscription.id).destroy
      flash[:alert] = 'You successfully unsubscriped the Quouch service. Sad to see you go!'
    else
      flash[:alert] = 'Something went wrong. Please try again or contact the Quouch Team.'
    end
    redirect_to new_subscription_path
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

  def display_plans
    @plans = Plan.all
    @monthly = get_plans(@plans, 'month')
    @yearly = get_plans(@plans, 'year')
  end

  def create_checkout_session(subscription)
    Stripe::Checkout::Session.create({
      customer: current_user.stripe_id,
      payment_method_types: ['card'],
      line_items: [{
        price: subscription.plan.stripe_price_id,
        quantity: 1
      }],
      mode: 'subscription',
      success_url: subscription_url(subscription),
      cancel_url: new_subscription_url
    })
  end
end
