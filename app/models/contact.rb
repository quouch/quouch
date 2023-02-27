class Contact < MailForm::Base
  attribute :name, validate: true
  attribute :email, validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message, validate:true
  attribute :nickname, captcha: true

  def headers
    { 
      to: "dev.quouch@gmail.com",
      subject: "Contact Form",
      from: "#{email}",
      reply_to: %("#{name}" <#{email}>) 
    }
  end
end
