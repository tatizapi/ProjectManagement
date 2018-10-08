class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def format_date(date)
    if date.today?
      date.strftime("%H:%M")
    elsif date.to_date == Date.yesterday
      "yesterday"
    elsif date.to_date.year != Date.current.year
      date.strftime("%d / %m / %Y")
    else
      date.strftime("%-d %^b.")
    end
  end
end
