class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def format_date(date)
    if date.today?
      date.strftime("%H:%M")
    elsif date.to_date == Date.yesterday
      "yesterday"
    else
      date.strftime("%d %^b")
    end
  end
end
