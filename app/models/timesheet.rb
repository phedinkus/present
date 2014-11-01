class Timesheet < ActiveRecord::Base
  belongs_to :user
  has_many :projects_timesheets
  has_many :projects, :through => :projects_timesheets
  has_many :entries, :through => :projects_timesheets

  accepts_nested_attributes_for :projects, :allow_destroy => true
  accepts_nested_attributes_for :projects_timesheets
  accepts_nested_attributes_for :entries

  validate :presence_of_projects_timesheets_notes, :if => ->(t){ t.week.invoice_week? && t.ready_to_invoice?}

  def self.find_or_create_for!(week, user)
    if existing = find_and_include_stuff(params = week.ymd_hash.merge(:user => user))
      existing
    else
      find_or_create_for!(week.previous, user) if week.invoice_week? #=> always ensure previous week is created first.
      Timesheet.new(params).tap do |timesheet|
        timesheet.projects += timesheet.previous_timesheets_projects
        timesheet.projects += Project.sticky.includes(:client)
        timesheet.save!
      end
    end
  end

  def self.find_and_include_stuff(params)
    where(params).includes(:projects => :client, :entries => :location).first
  end

  def self.current_and_past
    where("DATE(timesheets.year||'-'||timesheets.month||'-'||timesheets.day) < now()")
  end

  def self.future
    where("DATE(timesheets.year||'-'||timesheets.month||'-'||timesheets.day) > now()")
  end

  def self.between_inclusive(start_date, end_date)
    on_or_after(start_date).on_or_before(end_date)
  end

  def self.on_or_after(date)
    where("(timesheets.year > :year) or
           (timesheets.year = :year and timesheets.month > :month) or
           (timesheets.year = :year and timesheets.month = :month and timesheets.day >= :day)",
      :year => date.year,
      :month => date.month,
      :day => date.day
    )
  end

  def self.on_or_before(date)
    where("(timesheets.year < :year) or
           (timesheets.year = :year and timesheets.month < :month) or
           (timesheets.year = :year and timesheets.month = :month and timesheets.day <= :day)",
      :year => date.year,
      :month => date.month,
      :day => date.day
    )
  end

  def mark_ready_to_invoice!
    raise "Only invoice-week timesheets can be marked ready for invoice" unless week.invoice_week?
    update(:ready_to_invoice => true)
    previous_timesheet.update!(:ready_to_invoice => true) if errors.empty?
  end

  def previous_timesheet
    self.class.find_by(params = week.previous.ymd_hash.merge(:user => user))
  end

  def next_timesheet
    self.class.find_by(params = week.next.ymd_hash.merge(:user => user))
  end

  def previous_timesheets_projects
    return [] unless timesheet = previous_timesheet
    timesheet.projects.includes(:client)
  end

  def projects_timesheet_for(project)
    projects_timesheets.find {|pt| pt.project == project }
  end

  def entries_for(projects_timesheet)
    projects_timesheet.find_or_create_entries!
  end

  def week
    Week.for(year, month, day)
  end

  def time
    Time.zone.local(year, month, day)
  end

  def empty?
    entries.all?(&:zero?)
  end

  def locked?
    ready_to_invoice?
  end

  def non_empty_weekend_entries?
    entries.select(&:weekend?).any?(&:nonzero?)
  end

  def presence_of_projects_timesheets_notes
    projects_timesheets.
      select {|pt| pt.project.requires_notes? && pt.notes.blank? }.each do |pt|
        errors.add(:required_summary_notes, "are missing for the '#{pt.project.name}' project")
      end
  end
end
