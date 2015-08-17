module ApplicationHelper

  def format_time_diff(start_time, end_time)
    diff_hash = TimeDifference.between(start_time, end_time).in_general
    result = 'Just now'
    if ((value = diff_hash[:years]) > 0)
      result = "#{value} yrs ago"
    elsif ((value = diff_hash[:months]) > 0)
      result = "#{value} mos ago"
    elsif ((value = diff_hash[:weeks]) > 0)
      result = "#{value} wks ago"
    elsif ((value = diff_hash[:days]) > 0)
      result = "#{value} days ago"
    elsif ((value = diff_hash[:hours]) > 0)
      result = "#{value} hrs ago"
    elsif ((value = diff_hash[:minutes]) > 0)
      result = "#{value} mins ago"
    elsif ((value = diff_hash[:seconds]) > 0)
      result = "#{value} secs ago"
    end

    result
  end

end
