module D7P2
  class D7P2
    def run(input)
      hands = []
      input.each do |line|
        cards, bid = line.split(" ")
        bid = bid.to_i
        hands.push Hand.new(cards, bid)
      end
      hands.sort!
      sum = 0
      hands.each_with_index do |hand, idx|
        #puts "#{hand.cards}, #{hand.bid}, #{hand.type}, #{idx+1}"
        sum += (hand.bid * (idx+1))
      end
      puts "Sum: #{sum}"
    end
  end
  class Hand
    RANKS = [:high_card, :one_pair, :two_pair, :three_of_a_kind, :full_house, :four_of_a_kind, :five_of_a_kind]
    CARDS = ["J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"]
    attr_reader :bid, :type, :cards
    def initialize(cards, bid)
      @cards = cards
      @bid = bid
      @type = get_type
    end
    def get_type
      cards = @cards.split("").uniq
      jokers = @cards.count("J")
      case cards.count
      when 1
        return :five_of_a_kind
      when 5
        return :high_card if jokers == 0
        return :one_pair
      when 4
        return :one_pair if jokers == 0
        return :three_of_a_kind if jokers == 1 or jokers == 2
      when 2, 3
        counts = [nil, 0, 0, 0, 0]
        cards.each do |card|
          count = @cards.split("").count(card)
          counts[count] += 1
        end
        if counts[2] == 2
          return :two_pair if jokers == 0
          return :full_house if jokers == 1
          return :four_of_a_kind if jokers == 2
        elsif counts[3] == 1 and counts[2] == 0
          return :three_of_a_kind if jokers == 0
          return :four_of_a_kind if jokers == 1 or jokers == 3
        elsif counts[3] == 1 and counts[2] == 1
          return :full_house if jokers == 0
          return :five_of_a_kind if jokers == 2 or jokers == 3
        elsif counts[4] == 1
          return :four_of_a_kind if jokers == 0
          return :five_of_a_kind if jokers == 1 or jokers == 4
        end
      end
    end
    def <=> (other)
      a = RANKS.index(@type)
      b = RANKS.index(other.type)
      if a != b
        return a <=> b
      else
        a = -1
        b = -1
        idx = 0
        loop do
          a = CARDS.index(@cards[idx])
          b = CARDS.index(other.cards[idx])
          break if a != b or idx == 4
          idx += 1
        end
        return a <=> b
      end
    end
  end
end
