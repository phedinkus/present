class TimesheetReminderMailer < ActionMailer::Base
  ADMIN_EMAIL = "finances@testdouble.com"
  default from: ADMIN_EMAIL

  def reminder_email(user)
    @user = user
    mail(to: @user.github_account.email, subject: 'Present: Ready to invoice?')
  end

  def reminder_failed_email(user)
    @user = user
    mail(to: ADMIN_EMAIL, subject: "Failed to remind #{user.name}")
  end
end
