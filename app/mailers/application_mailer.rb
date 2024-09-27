class ApplicationMailer < ActionMailer::Base
  self.queue_adapter = :inline
  default from: 'hello@quouch-app.com'
  layout 'mailer'
end
