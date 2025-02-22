module D5P2
  class D5P2
    def run(input)
      polymer = input.first
      units = polymer.downcase.split("").uniq
      polymer = polymer.split("")
      tests = []
      units.each do |unit|
        modified_polymer = polymer.dup
        modified_polymer.delete(unit)
        modified_polymer.delete(unit.capitalize)
        idx = 0
        while idx < modified_polymer.length-1
          if modified_polymer[idx] and modified_polymer[idx+1]
            if (modified_polymer[idx].ord -  modified_polymer[idx+1].ord).abs  == 32
              2.times { modified_polymer.delete_at(idx) }
              idx -= 1
            else
              idx += 1
            end
          end
        end
        tests.push modified_polymer.length
      end

      puts "Length: #{tests.min}"
    end
  end
end
