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
    add_stripe_id_to_user unless current_user.stripe_id
    subscription = create_subscription
    checkout_session = create_checkout_session(subscription)
    subscription.checkout_session_id = checkout_session.id
    subscription.save! if redirect_to checkout_session.url, allow_other_host: true
  end

  def update
    subscription = Stripe::Subscription.retrieve(@subscription.stripe_id)
    subscription.cancel_at_period_end = true
    return unless subscription.save

    flash[:alert] = if @subscription.update!(end_of_period: Time.at(subscription.current_period_end).to_date)
                      'You successfully unsubscribed the Quouch service. Sad to see you go after this billing cycle ends!'
                    else
                      'Something went wrong. Please try again or contact the Quouch Team.'
                    end
    redirect_to subscription_path(@subscription)
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.require(:data).permit(:user_id, :plan_id, :active)
  end

  def get_plans(plans, interval)
    plans.where(interval:).order('price_cents')
  end

  def display_plans
    @plans = Plan.all
    @monthly = get_plans(@plans, 'month')
    @yearly = get_plans(@plans, 'year')
  end

  def create_subscription
    plan_id = params[:plan_id]
    subscription_id = Subscription.last ? Subscription.last.id + 1 : 1
    Subscription.new(id: subscription_id, plan_id:, user_id: current_user.id)
  end

  def create_checkout_session(subscription)
    Stripe::Checkout::Session.create(
      {
        customer: current_user.stripe_id,
        payment_method_types: %w[card paypal],
        line_items: [{
          price: subscription.plan.stripe_price_id,
          quantity: 1
        }],
        mode: 'subscription',
        success_url: subscription_url(subscription),
        cancel_url: new_subscription_url
      }
    )
  end

  def add_stripe_id_to_user
    response = Stripe::Customer.create(email: current_user.email)
    current_user.update!(stripe_id: response.id)
  end
end
