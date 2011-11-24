ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => "banta.bernard", #Your user name
  :password             => "Gkaribu82E", # Your password
  :authentication       => "plain",
  :enable_starttls_auto => true
}