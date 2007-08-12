module InfoHelper
  def years_of_service(hire_date)
    days = Date.today - hire_date
    (days.to_i / 365)
  end
end
