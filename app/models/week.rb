class Week
  attr_reader :year, :ordinal, :beginning, :end

  def self.now
    new(Time.zone.now)
  end

  def self.for(year, ordinal)
    new(ordinal.to_i.weeks.since(Time.zone.local(year)).beginning_of_week(:sunday))
  end

  def initialize(time)
    @beginning = time.beginning_of_week(:sunday)
    @end = @beginning.end_of_week(:sunday)
    @year = @beginning.year
    @ordinal = @beginning.strftime("%U").to_i
  end

  def next
    self.class.new(@end + 1)
  end

  def previous
    self.class.new(@beginning - 1)
  end
end
