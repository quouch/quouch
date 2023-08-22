class Contact < MailForm::Base
  attribute :name, validate: true
  attribute :email, validate: /\A([\w.%+-]+)@([\w-]+\.)+(\w{2,})\z/i
  attribute :message, validate: true
  attribute :source
  attribute :nickname, captcha: true

  attr_accessor :type

  def headers
    subject_prefix = type == 'contact' ? 'Contact Form' : 'Request for Invite Code'

    {
      to: 'nora@quouch-app.com',
      subject: subject_prefix.to_s,
      from: email.to_s,
      reply_to: %("#{name}" <#{email}>)
    }
  end
end
