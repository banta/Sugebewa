class Notifications < ActionMailer::Base
  default :from => "Banta Bernard <banta.bernard@gmail.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.forgot_password.subject
  #
  def forgot_password(to, name, pass)
    mail(
      :to    => to,
      :subject => "Sugebewa",
      :body => "Name is: #{name}.\n
Your new password is #{pass}\n
Please login and change it to something more memorable.\n
Click here this link to login http://sugebewa.com/signin\n\n"
    )
  end
end