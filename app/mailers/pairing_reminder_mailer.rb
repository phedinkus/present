class PairingReminderMailer < ActionMailer::Base
  default from: "doubot@testdouble.com"

  def reminder_email(user)
    @user = user
    mail(to: @user.github_account.email, subject: "It's a great day to pair with someone new!")
  end
end
