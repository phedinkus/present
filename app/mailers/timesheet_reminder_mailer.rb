class TimesheetReminderMailer < ActionMailer::Base
  default from: "finances@testdouble.com"

  def reminder_email(user)
    @user = user
    mail(to: @user.github_account.email, subject: 'Present: Ready to invoice?')
  end
end
