class SubscriptionMailer < ApplicationMailer
  default from: "Quouch <hello@quouch-app.com>"
  before_action :set_subscription_details

  def subscription_cancelled
    mail(to: @subscriber.email, subject: "Quouch Membership Cancellation")
  end

  def subscription_successful
    mail(to: @subscriber.email, subject: "Welcome to Quouch! Your Membership Plan Confirmation")
  end

  private

  def set_subscription_details
    @subscription = params[:subscription]
    @subscriber = @subscription.user
    @plan = @subscription.plan
    @feedback_form_guest = "https://forms.gle/mAiFEpxrw5PsbKD87"
    @feedback_form_host = "https://forms.gle/AwrdCDawwWJ1VNvL9"
    @feedback_form_app = "https://forms.gle/by6szdpGKtpfv6mD7"
  end
end
