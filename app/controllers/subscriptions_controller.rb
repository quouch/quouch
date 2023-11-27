class SubscriptionsController < ApplicationController
  before_action :set_subscription, except: %i[new payment]

  def new
    display_plans
  end

  def show
    display_plans
    @plan = current_user.subscriptions.find_by(active: true).plan
  end

  def payment
    plan_id = params[:plan_id]
    subscription_id = Subscription.last ? Subscription.last.id + 1 : 1
    subscription = Subscription.new(id: subscription_id, plan_id:, user_id: current_user.id)
    checkout_session = create_checkout_session(subscription)
    subscription.checkout_session_id = checkout_session.id
    subscription.save! if redirect_to checkout_session.url, allow_other_host: true
  end

  def update
    plan_id = params[:plan_id]
    id = Subscription.last.id + 1
    new_subscription = Subscription.new(id:, plan_id:, user: current_user, active: false)
    cancel_inactive_subscriptions if current_user.subscriptions.count > 2
    if create_new_subscription(@subscription, new_subscription)
      Stripe::Subscription.update(
        @subscription.stripe_id,
        { cancel_at_period_end: true }
      )
    end
  end

  def destroy
    inactive_subscriptions = current_user.subscriptions.where(active: false)
    active_subscription = current_user.subscriptions.find(active: true)
    cancel_all_subscriptions(inactive_subscriptions, active_subscription)
    flash[:alert] = if cancel_all_subscriptions
                      'You successfully unsubscribed the Quouch service. Sad to see you go after this billing cycle ends!'
                    else
                      'Something went wrong. Please try again or contact the Quouch Team.'
                    end
    redirect_to subscription_path(active_subscription)
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
    Stripe::Checkout::Session.create(
      {
        customer: current_user.stripe_id,
        payment_method_types: ['card'],
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

  def create_new_subscription(current_subscription, new_subscription)
    checkout_session = Stripe::Checkout::Session.create(
      {
        customer: current_user.stripe_id,
        payment_method_types: ['card'],
        mode: 'setup',
        success_url: subscription_url(new_subscription.id),
        cancel_url: subscription_url(current_subscription.id)
      }
    )

    new_subscription.checkout_session_id = checkout_session.id
    new_subscription.save!
    redirect_to checkout_session.url, allow_other_host: true
  end

  def cancel_inactive_subscriptions(inactive_subscriptions)
    inactive_subscriptions.each do |subscription|
      session = Stripe::Checkout::Session.retrieve(subscription.checkout_session_id)
      subscription.destroy if Stripe::Subscription.cancel(session.subscription)
    end
  end

  def cancel_active_subscription(active_subscription)
    begin
      subscription = Stripe::Subscription.retrieve(active_subscription.stripe_id)
      subscription.cancel_at_period_end = true
      subscription.save
    rescue Stripe::StripeError => e
      puts "Stripe error while updating subscription: #{e.message}"
    end
  end

  def cancel_all_subscriptions
    cancel_inactive_subscriptions
    cancel_active_subscription
  end
end
