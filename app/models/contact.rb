class Contact < MailForm::Base
  attribute :name, validate: true
  attribute :email, validate: /\A([\w.%+-]+)@([\w-]+\.)+(\w{2,})\z/i
  attribute :message, validate: true
  attribute :source
  attribute :nickname, captcha: true

  attr_accessor :type, :couch

  def headers
    case type
    when 'contact'
      subject_prefix = 'Contact Form'
      {
        to: 'nora@quouch-app.com',
        subject: subject_prefix.to_s,
        from: email.to_s,
        reply_to: %("#{name}" <#{email}>)
      }
    when 'code'
      subject_prefix = 'Request for Invite Code'
      {
        to: 'nora@quouch-app.com',
        subject: subject_prefix.to_s,
        from: email.to_s,
        reply_to: %("#{name}" <#{email}>)
      }
    when 'report'
      subject_prefix = 'User Report'
      {
        to: 'nora@quouch-app.com',
        subject: "#{subject_prefix} of Couch #{couch}",
        from: email.to_s,
        reply_to: %("#{name}" <#{email}>)
      }
    end
  end
end
