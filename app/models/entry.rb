class Entry < ActiveRecord::Base
  belongs_to :projects_timesheet
  has_one :project, :through => :projects_timesheet
  has_one :timesheet, :through => :projects_timesheet

  before_save :set_default_presence, :if => lambda { |e| e.presence.nil? }

  enum :day => {
    :sunday => 0,
    :monday => 1,
    :tuesday => 2,
    :wednesday => 3,
    :thursday => 4,
    :friday => 5,
    :saturday => 6
  }

  enum :presence => {
    :full => 0,
    :half => 1,
    :absent => 2,
    :hourly => 3
  }

private

  def set_default_presence
    self.presence = if sunday? || saturday? || timesheet.projects.first != project
      :absent
    else
      :full
    end
  end


end
