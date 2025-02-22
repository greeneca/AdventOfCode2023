module D4P1
  class D4P1
    def run(input)
      input.map! do |line|
        match_data = /\[([^\]]*)\] (.*)/.match(line)
        {
          time: DateTime.parse(match_data[1]),
          message: match_data[2]
        }
      end
      input.sort! {|a, b| a[:time] <=> b[:time]}
      guards = {}
      current_guard = nil
      sleep_start = nil
      input.each do |event|
        if match_data = /Guard (.*) begins shift/.match(event[:message])
          current_guard = match_data[1]
          guards[current_guard] ||= {
            minutes_asleep: Array.new(60, 0),
            total: 0
          }
          sleep_start = nil
        elsif "falls asleep" == event[:message]
          sleep_start = event[:time].minute
        elsif "wakes up" == event[:message]
          if current_guard and sleep_start
            (sleep_start..event[:time].minute-1).each do |min|
              guards[current_guard][:minutes_asleep][min] += 1
            end
            guards[current_guard][:total] +=event[:time].minute - sleep_start
          end
          sleep_start = nil
        end
      end

      most_sleep = guards.keys.first
      guards.each_pair do |guard, info|
        if info[:total] > guards[most_sleep][:total]
          most_sleep = guard
        end
      end
      most_sleep_minute = 0
      guards[most_sleep][:minutes_asleep].each_with_index do |sleep, idx|
        if sleep > guards[most_sleep][:minutes_asleep][most_sleep_minute]
          most_sleep_minute = idx
        end
      end
      puts "Answer: #{most_sleep[1..-1].to_i * most_sleep_minute}"
    end
  end
end
