class GathersDossiers
  def gather(time = Time.zone.now, mission_count = 3)
    User.active.map do |user|
      Dossier.new(user, mission_count.times.map { |i|
        mission_for(user, time + i.months)
      })
    end
  end

private

  def mission_for(user, time)
    Mission.find_or_initialize_by(
      :user => user,
      :year => time.year,
      :month => time.month).tap do |m|
        if m.project.
    end
  end
end
