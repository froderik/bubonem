[:day, :night].each do |kind|
  (1..27).each do |n|
    end_of_path = "#{kind}/#{n}.png"
    source = "https://www.smhi.se/tendayforecast/images/WPT-icons/weathersymbols/80x60/#{end_of_path}?v=1550503846134&proxy=wpt-abc"
    target = "../public/weathersymbols/#{end_of_path}"

    p "------ saving #{source} to #{target}"
    
    `wget -O #{target} '#{source}'`
  end
end
