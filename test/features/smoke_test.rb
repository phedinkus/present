require "test_helper"

describe "Smoke", :capybara do

  Given do
    ActiveRecord::Base.descendants.map(&:delete_all)
    Api::Harvest.wipe!
    Seeds::Project.seed!
    Seeds::Location.seed!
    Seeds::SystemConfiguration.seed!
  end

  Given(:client_name) { "Acme #{Time.zone.now.to_i}" }
  Given(:project_name) { "Build Things #{Time.zone.now.to_i}" }
  Given { Pages::App.visit! }
  Given { Pages::Github.login_if_necessary! }
  Given { assert Pages::Timesheet.rendered? }
  Given { Pages::NewClient.visit! }
  Given { Pages::NewClient.create!(client_name) }
  Given { Pages::NewProject.visit! }
  Given { Pages::NewProject.create!(client_name, project_name) }
  Given { Pages::Timesheet.visit! }
  Given { Pages::Timesheet.go_to_prior_invoicing_week! }
  Given { Pages::Timesheet.add_billable_project!(project_name) }
  Given { Pages::Timesheet.go_to_previous_week! }
  Given { Pages::Timesheet.add_billable_project!(project_name) }
  Given { Pages::Timesheet.go_to_next_week! }
  Given { Pages::Timesheet.mark_ready_to_invoice! }
  Given { Pages::InvoiceTodos.visit! }
  Given { assert Pages::InvoiceTodos.timesheets_look_good? }
  Given { Pages::InvoiceTodos.create_invoice!(client_name) }
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

module Api
  module Harvest
    def self.wipe!
      Present::Harvest::Connection.create.tap do |conn|
        [:invoices, :time, :projects, :clients].map {|name| conn.send(name) }.each do |resource|
          resource.all.each {|r| resource.delete(r.id) }
        end
      end
    end
  end
end

module Pages
  module Github
    extend Capybara::DSL

    def self.login_if_necessary!
      return unless login_necessary?
      fill_in "Username or email address", :with => ENV['PRESENT_TEST_GITHUB_ID']
      fill_in "Password", :with => ENV['PRESENT_TEST_GITHUB_PASSWORD']
      click_button "Sign in"
    end

    def self.login_necessary?
      all('label', :text => "Username or email address").present?
    end
  end

  module App
    extend Capybara::DSL
    extend ChosenSelect

    def self.visit!
      visit "/"
    end
  end

  module Timesheet
    extend Capybara::DSL
    extend ChosenSelect

    def self.visit!
      click_link('Home')
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

    def self.add_billable_project!(project_name)
      select_from_chosen(project_name, :from => "Add Project")
      click_button("Add Project")
      page.must_have_content("Project '#{project_name}' added!")
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

    def self.create_invoice!(client_name)
      click_button("Create invoice")
      page.must_have_content("Invoice to #{client_name}")
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
      fill_in "Email", :with => Rails.application.secrets.harvest_username
      fill_in "Password", :with => Rails.application.secrets.harvest_password
      click_button "Sign In"
    end

    def self.verify!
      rate = ENV['PRESENT_WEEKLY_RATE'].to_d
      formatted_rate = number_to_currency(rate)

      page.must_have_content("Service")
      page.must_have_content("(10.0/10.0 days worked)")
      page.must_have_content("2.00")
      page.must_have_content(formatted_rate)
      page.must_have_content("Amount Due #{number_to_currency(rate*2)}")
      page.must_have_content("Thank you!\n\nUnit Price and Quantity reflect a weekly rate of #{formatted_rate}")
    end
  end

  module NewClient
    extend Capybara::DSL

    def self.visit!
      click_link("Clients")
      click_link("New Client")
    end

    def self.create!(client_name)
      fill_in("Name", :with => client_name)
      click_button("Save")
    end
  end

  module NewProject
    extend Capybara::DSL

    def self.visit!
      click_link("Projects")
      click_link("New Project")
    end

    def self.create!(client_name, project_name)
      select(client_name, :from => "Client")
      fill_in("Name", :with => project_name)
      click_button("Save")
    end
  end
end
