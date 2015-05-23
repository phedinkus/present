module Queries
  module YearMonthDay

    def current_and_past
      where("DATE(#{table_name}.year||'-'||#{table_name}.month||'-'||#{table_name}.day) < now()")
    end

    def future
      where("DATE(#{table_name}.year||'-'||#{table_name}.month||'-'||#{table_name}.day) > now()")
    end

    def between_inclusive(start_date, end_date)
      on_or_after(start_date).on_or_before(end_date)
    end

    def on_or_after(date)
      where("(#{table_name}.year > :year) or
             (#{table_name}.year = :year and #{table_name}.month > :month) or
             (#{table_name}.year = :year and #{table_name}.month = :month and #{table_name}.day >= :day)",
        :year => date.year,
        :month => date.month,
        :day => date.day
      )
    end

    def for_week(week)
      where(
        :year => week.year,
        :month => week.month,
        :day => week.day
      )
    end

    def on_or_before(date)
      where("(#{table_name}.year < :year) or
             (#{table_name}.year = :year and #{table_name}.month < :month) or
             (#{table_name}.year = :year and #{table_name}.month = :month and #{table_name}.day <= :day)",
        :year => date.year,
        :month => date.month,
        :day => date.day
      )
    end
  end
end
