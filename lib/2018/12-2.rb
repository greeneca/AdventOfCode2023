module D12P2
  class D12P2
    TARGET_GENERATION = 50000000000
    def run(input)
      start = 0
      generation = 0
      state = /initial state:\s(.*)/.match(input.shift)[1]
      input.shift
      checks = []
      input.each do |line|
        match_data = /([.|#]{5})\s=>\s([.|#])/.match(line)
          checks.push({
            pattern: match_data[1],
            result: match_data[2]
          })
      end

      #print_state(generation, start, state)

      diff_match_count = 0
      last_sum = 0
      last_diff = 0
      while diff_match_count < 10
        empty_add = 5 - state.index("#")
        if empty_add > 0
          state = ("."*empty_add)+state
          start -= empty_add
        end
        empty_add = 5 - (state.size - state.rindex("#"))
        if empty_add > 0
          state += "."*empty_add
        end

        next_gen = Array.new(state.size)
        checks.each do |check|
          offset = 0
          while index = state.index(check[:pattern], offset)
            next_gen[index+2] = check[:result]
            offset = index+1
          end
        end
        next_gen.each_with_index do |pot, index|
          unless pot
            next_gen[index] = "."
          end
        end
        state = next_gen.join
        generation += 1
        #print_state(generation, start, state)
        sum = sum(state, start)
        diff = sum - last_sum
        if diff == last_diff
          diff_match_count += 1
        else
          diff_match_count = 0
          last_diff = diff
        end
        last_sum = sum
      end

      puts last_sum + (TARGET_GENERATION - generation)*last_diff
    end
    def print_state(generation, start, state)
      printf "%2d(%2d): %s\n", generation, start, state
    end
    def sum(state, start)
      offset = 0
      total = 0
      while index = state.index("#", offset)
        offset = index + 1
        total += index+start
      end
      total
    end
  end
end
