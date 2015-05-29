require "test_helper"

describe "Smoke", :capybara do
  Given { Rake::Task["db:setup"].invoke }

  Given { Pages::Timesheet.visit! }
  Given { Pages::Github.login! }
  Given { assert Pages::Timesheet.rendered? }
  Given { Pages::Timesheet.go_to_prior_invoicing_week! }
  Given { Pages::Timesheet.add_billable_project! }
  Given { Pages::Timesheet.go_to_previous_week! }
  Given { Pages::Timesheet.add_billable_project! }
  Given { Pages::Timesheet.go_to_next_week! }
  Given { Pages::Timesheet.mark_ready_to_invoice! }
  Given { Pages::InvoiceTodos.visit! }
  Given { assert Pages::InvoiceTodos.timesheets_look_good? }
  Given { Pages::InvoiceTodos.create_invoice! }
  Given { Pages::ViewInvoice.send_to_harvest! }
  When { Pages::ViewInvoice.view_invoice_in_harvest! }
  Then { Pages::HarvestInvoice.verify! }
end

module ChosenSelect
  def select_from_chosen(item_text, options)
    field = find_field(options[:from], visible: false)
    option_value = page.evaluate_script("$(\"##{field[:id]} option:contains('#{item_text}')\").val()")
    page.execute_script("value = ['#{option_value}']\; if ($('##{field[:id]}').val()) {$.merge(value, $('##{field[:id]}').val())}")
    option_value = page.evaluate_script("value")
    page.execute_script("$('##{field[:id]}').val(#{option_value})")
    page.execute_script("$('##{field[:id]}').trigger('chosen:updated')")
  end
end

module Pages
  module Github
    extend Capybara::DSL

    def self.login!
      fill_in "Username or Email", :with => ENV['PRESENT_TEST_GITHUB_ID']
      fill_in "Password", :with => ENV['PRESENT_TEST_GITHUB_PASSWORD']
      click_button "Sign in"
    end
  end

  module Timesheet
    extend Capybara::DSL
    extend ChosenSelect

    def self.visit!
      visit "/"
    end

    def self.rendered?
      page.has_content?("Welcome,") && page.has_button?("Update Timesheet")
    end

    def self.go_to_prior_invoicing_week!
      go_to_previous_week!
      return if invoice_week?
      go_to_previous_week!
    end

    def self.go_to_previous_week!
      click_button("Previous Week")
    end

    def self.go_to_next_week!
      click_button("Next Week")
    end

    def self.add_billable_project!
      select_from_chosen("Build Stuff", :from => "Add Project")
      click_button("Add Project")
      page.must_have_content("Project 'Build Stuff' added!")
    end

    def self.invoice_week?
      page.has_button?("Ready to Invoice", :wait => 0.5)
    end

    def self.mark_ready_to_invoice!
      click_button("Ready to Invoice")
      accept_alert rescue Capybara::NotSupportedByDriverError
      page.must_have_content("Saved & Marked Ready for invoice!")
      page.must_have_content("This timesheet is ") #<-- "lock-icon'd"
    end
  end

  module InvoiceTodos
    extend Capybara::DSL

    def self.visit!
      click_link("Invoices Waiting for Submission")
      page.must_have_content("Invoice Status")
    end

    def self.timesheets_look_good?
      page.has_content?("Timesheets look good")
    end

    def self.create_invoice!
      click_button("Create invoice")
      page.must_have_content("Invoice to Acme")
    end
  end

  module ViewInvoice
    extend Capybara::DSL

    def self.send_to_harvest!
      click_button("Send invoice to Harvest")
      page.must_have_content("Sent invoice to Harvest!")
    end

    def self.view_invoice_in_harvest!
      click_link("View invoice in Harvest", :wait => 10) #<-- harvest is slow sometimes
      HarvestInvoice.login! if page.has_field?("Password")
    end
  end

  module HarvestInvoice
    extend Capybara::DSL
    extend ActionView::Helpers::NumberHelper

    def self.login!
      fill_in "Email", :with => ENV['PRESENT_HARVEST_USERNAME']
      fill_in "Password", :with => ENV['PRESENT_HARVEST_PASSWORD']
      click_button "Sign In"
    end

    def self.verify!
      rate = ENV['PRESENT_WEEKLY_RATE'].to_d

      page.must_have_content("Service")
      page.must_have_content("(10.0/10.0 days worked)")
      page.must_have_content("2.00")
      page.must_have_content(number_to_currency(rate))
      page.must_have_content("Amount Due #{number_to_currency(rate * 2)}")
    end
  end


end
