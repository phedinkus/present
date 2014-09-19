class Entry < ActiveRecord::Base
  belongs_to :projects_timesheet
  has_one :project, :through => :projects_timesheet
  has_one :timesheet, :through => :projects_timesheet
  has_one :user, :through => :timesheet
  belongs_to :location
  belongs_to :updated_by, :class_name => "User"

  validates_numericality_of :hours
  validates_presence_of :location
  validates_inclusion_of :presence, :in => :valid_presences, :allow_nil => true

  before_save :set_default_presence, :if => lambda { |e| e.presence.nil? }
  before_validation :set_default_location, :unless => lambda { |e| e.location.present? }
  before_update :restore_disallowed_attributes_when_timesheet_is_locked, :if => lambda { |e| e.timesheet.try(:locked?) && e.project.try(:billable?) }

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

  def self.between_inclusive(start_date, end_date)
    joins(:timesheet).
      merge(Timesheet.between_inclusive(start_date,end_date)).
      select { |e| e.date.between?(start_date, end_date) }
  end

  def self.time_for(timesheet, day_name)
    t = timesheet.time
    until Date::DAYNAMES[t.wday].downcase == day_name.to_s
      t += 1.day
    end
    t
  end

  def time
    self.class.time_for(timesheet, day)
  end

  def date
    time.to_date
  end

  def self.weekend?(day_name)
    ["sunday", "saturday"].include?(day_name.to_s)
  end

  def weekend?
    self.class.weekend?(day)
  end

  def zero?
    hourly? ? hours == 0 : absent?
  end

  def nonzero?
    !zero?
  end

  def price
    if project.non_billable?
      0
    elsif project.weekly?
      (1.to_d / 5) * project.weekly_rate * presence_proportion
    elsif project.hourly?
      hours.to_d * project.hourly_rate
    end
  end
private

  def valid_presences
    return ["hourly"] if project.hourly?
    self.class.presences.keys - ["hourly"]
  end

  def set_default_presence
    self.presence = if project.hourly?
      :hourly
    elsif weekend? || timesheet.projects.reject(&:special?).first != project
      :absent
    else
      :full
    end
  end

  def set_default_location
    self.location = timesheet.user.location
  end

  def restore_disallowed_attributes_when_timesheet_is_locked
    assign_attributes(Entry.find(id).attributes.except(
      "location_id"
    ))
  end

  def presence_proportion
    case presence
      when "full" then 1.0
      when "half" then 0.5
      when "absent" then 0.0
    end
  end

end
