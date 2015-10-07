require "test_helper"

describe Timesheet do
  describe "validation" do
    subject { timesheets(:two) }
    Then { subject.valid? }

    describe 'requires_notes validation' do
      Given { Seeds::SystemConfiguration.seed! }
      Given(:project) { subject.projects.first }
      Given(:projects_timesheet) { subject.projects_timesheets.find {|pt| pt.project == project } }

      Given { project.update!(:requires_notes => true) }
      Given { subject.update(:ready_to_invoice => true) }

      context 'notes is empty' do
        Given { projects_timesheet.update!(:notes => nil) }

        context 'normal users on invoice weeks when ready to invoice with time' do
          Then { !subject.valid? }
        end

        context 'user is an admin' do
          around do |test|
            og_admins = Rails.application.config.present.admins.clone
            Rails.application.config.present.admins << subject.user.github_account.login

            test.call

            Rails.application.config.present.admins  = og_admins
          end

          Then { subject.valid? }
        end

        context 'not an invoice week' do
          subject { timesheets(:one) }
          Then { subject.valid? }
        end

        context 'not ready to invoice' do
          Given { subject.update!(:ready_to_invoice => false) }
          Then { subject.valid? }
        end

        context 'total entries time is zero' do
          Given { projects_timesheet.entries.each { |e| e.update!(:presence => "absent") } }
          Then { subject.valid? }
        end
      end

      context 'notes are provided' do
        Given { projects_timesheet.update!(:notes => "I'm a note!") }
        Then { subject.valid? }
      end
    end
  end
end
