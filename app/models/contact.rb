class Contact < MailForm::Base
  attribute :name, validate: true
  attribute :email, validate: /\A([\w.%+-]+)@([\w-]+\.)+(\w{2,})\z/i
  attribute :message, validate: true
  attribute :source
  attribute :nickname, captcha: true

  attr_accessor :type, :couch

  def headers
    subject_prefix = case type
    when "contact" then "Contact Form"
    when "code" then "Request for Invite Code"
    when "report" then "User Report of Couch #{couch}"
    end

    {
      to: "hello@quouch-app.com",
      subject: subject_prefix.to_s,
      from: email.to_s,
      reply_to: %("#{name}" <#{email}>)
    }
  end
end
