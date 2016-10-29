def wait_for_visible(*args)
  wait_for do
    element = first(*args)
    element && element.visible?
  end
end

def host_redirected?(timeout = Capybara.default_max_wait_time)
  old_url = URI.parse(current_url).host
  wait_for(timeout) do
    url = URI.parse(current_url).host
    old_url != url
  end
end

def wait_for(timeout=Capybara.default_max_wait_time, &condition)
  def bool_func_call(bool_func, safe=true)
    if safe
      begin
        return_value = bool_func.call
        if return_value.in?([true, false])
          return_value
        else
          false
        end
      rescue RSpec::Expectations::ExpectationNotMetError
        false
      end
    else
      bool_func.call
    end
  end

  time_before = Time.now
  while Time.now - time_before < timeout
    break if bool_func_call(condition) == true
    sleep 0.1
  end

  bool_func_call(condition, false)
end
