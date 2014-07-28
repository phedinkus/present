class Week
  attr_reader :year, :month, :day, :beginning, :end

  def self.now
    new(Time.zone.now)
  end

  def self.for(year, month, day)
    new(Time.zone.local(year, month, day))
  end

  def initialize(time)
    @beginning = time.beginning_of_week(:sunday)
    @end = @beginning.end_of_week(:sunday)
    @year = @beginning.year
    @month = @beginning.month
    @day = @beginning.day
  end

  def next
    self.class.new(@end + 1)
  end

  def previous
    self.class.new(@beginning - 1)
  end
end
