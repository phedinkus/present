class GathersDossiers

  def initialize(reference_time = Time.zone.now)
    @reference_time = reference_time
  end

  def gather(mission_count = 3)
    User.alpha_sort.active.map do |user|
      Dossier.new(user, mission_count.times.map { |i|
        mission_for(user, @reference_time + i.months)
      })
    end
  end

private

  def mission_for(user, time)
    Mission.find_or_initialize_by(
      :user => user,
      :year => time.year,
      :month => time.month).tap do |m|
        next if m.status.present?
        m.project ||= most_billed_recent_project(m.user)
        m.status ||= m.project.present? ? :tentative : :available
    end
  end

  def speculate_project_for(mission)
    if @reference_time > mission.time
      recently_billed_projects(mission.user)
    end

  end

  def most_billed_recent_project(user)
    user.entries.billable.
      joins(:timesheet).merge(Timesheet.between_inclusive(@reference_time - 3.weeks, @reference_time))
      .group_by(&:project).max_by { |(project, entries)| entries.size }.try(:first)
  end
end
