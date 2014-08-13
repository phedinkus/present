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

  def ymd_hash
    {
      :year => @year,
      :month => @month,
      :day => @day
    }
  end

  def ymd_dash
    @beginning.to_date.to_s(:db)
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

  def invoice_week?
    weeks_since(Rails.application.config.present.reference_invoice_week).to_i.even?
  end

  def weeks_since(earlier_week)
    ((beginning - earlier_week.beginning) / 1.week.seconds).to_i
  end

  def previous_invoice_week
    previous_week_that {|w| w != self && w.invoice_week? }
  end

  def next_invoice_week
    next_week_that {|w| w != self && w.invoice_week? }
  end

  def closest_invoice_week
    next_week_that {|w| w.invoice_week? }
  end

  def next_week_that(&block)
    find_week_by(1, block)
  end

  def previous_week_that(&block)
    find_week_by(-1, block)
  end

  def find_week_by(step, block)
    w = self
    until block.call(w)
      w += step
    end
    w
  end

  def same?(other_week)
    beginning == other_week.beginning
  end
end
