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

  def to_date
    Date.civil(@year,@month,@day)
  end

  def ymd_hash
    {
      :year => @year,
      :month => @month,
      :day => @day
    }
  end

  def ymd_dash
    to_date.to_s(:db)
  end

  def +(number_of_weeks)
    return self.-(number_of_weeks * -1) if number_of_weeks < 0
    number_of_weeks.times.reduce(self) do |memo|
      memo.next
    end
  end

  def -(number_of_weeks)
    return self.+(number_of_weeks * -1) if number_of_weeks < 0
    number_of_weeks.times.reduce(self) do |memo|
      memo.previous
    end
  end
end
