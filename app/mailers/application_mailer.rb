class ApplicationMailer < ActionMailer::Base
  default from: 'hello@quouch-app.com'
  layout 'mailer'
end
