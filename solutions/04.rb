class Card
  RANKS = {
            2 => ["2", 1],
            3 => ["3", 2],
            4 => ["4", 3],
            5 => ["5", 4],
            6 => ["6", 5],
            7 => ["7", 6],
            8 => ["8", 7],
            9 => ["9", 8],
            10 => ["10", 9],
            :jack => ["Jack", 10],
            :queen => ["Queen", 11],
            :king => ["King", 12],
            :ace => ["Ace", 13]
          }

  SUITS = {
            :spades => ["Spades", 1],
            :hearts => ["Hearts", 2],
            :diamonds => ["Diamonds", 3],
            :clubs => ["Clubs", 4]
          }

  attr_reader :rank, :suit, :rank_order, :suit_order

  def initialize(rank, suit)
    @rank, @suit = rank, suit
    @rank_order, @suit_order = RANKS[rank][1], SUITS[suit][1]
  end

  def to_s
    "#{RANKS[@rank][0]} of #{SUITS[@suit][0]}"
  end

  def ==(compare)
    self.to_s == compare.to_s
  end
end

class Hand
  SUITS = [:spades, :hearts, :diamonds, :clubs]

  attr_accessor :cards

  def initialize(cards)
    @cards = cards
  end

  def size
    @cards.length
  end
end

class Deck
  include Enumerable

  attr_accessor :deck_size, :hand_size, :cards

  SUITS = [:spades, :hearts, :diamonds, :clubs]

  def initialize(cards = [])
    @cards = []
    @ranks.each do |rank|
      SUITS.each { |suit| @cards.push(Card.new(rank[0], suit)) }
    end
    @cards = cards.empty? ? @cards : cards
  end

  def size
    @cards.length
  end

  def draw_top_card
    @cards.pop
  end

  def draw_bottom_card
    @cards.shift
  end

  def top_card
    @cards.last
  end

  def bottom_card
    @cards.first
  end

  def shuffle
    @cards.shuffle!
  end

  def sort
    @cards.sort! do |a, b|
      first = a.suit_order <=> b.suit_order
      second = b.rank_order <=> a.rank_order

      if not first == 0 then first * second else second end
    end
  end

  def to_s
    cards.each { |card| puts card.to_s }
  end

  def deal
    deal_cards = []
    (1..@hand_size).each do |i|
      card = self.draw_top_card
      deal_cards.push(Card.new(card.rank, card.suit))
    end
    self.class::Hand.new(deal_cards)
  end
end

class WarDeck < Deck
  RANKS = {
            2 => ["2", 1],
            3 => ["3", 2],
            4 => ["4", 3],
            5 => ["5", 4],
            6 => ["6", 5],
            7 => ["7", 6],
            8 => ["8", 7],
            9 => ["9", 8],
            10 => ["10", 9],
            :jack => ["Jack", 10],
            :queen => ["Queen", 11],
            :king => ["King", 12],
            :ace => ["Ace", 13]
          }

  def initialize(cards = [])
    @deck_size = 52
    @hand_size = 26
    @ranks = RANKS

    super
  end

  class Hand < Hand
    def play_card
      @cards.sample
    end

    def allow_face_up?
      @cards.length <= 3
    end
  end
end

class BeloteDeck < Deck
  RANKS = {
            7 => ["7", 1],
            8 => ["8", 2],
            9 => ["9", 3],
            :jack => ["Jack", 4],
            :queen => ["Queen", 5],
            :king => ["King", 6],
            10 => ["10", 7],
            :ace => ["Ace", 8]
          }

  def initialize(cards = [])
    @deck_size = 32
    @hand_size = 8
    @ranks = RANKS

    super
  end

  class Hand < Hand
    RANK_ORDER = [7, 8, 9, :jack, :queen, :king, 10, :ace]

    def sort
      @cards.sort! do |a, b|
        first = a.suit_order <=> b.suit_order
        second = b.rank_order <=> a.rank_order

        if not first == 0 then first * second else second end
      end
    end

    def highest_of_suit(suit)
      suit_cards = []

      self.sort
      @cards.each { |card| if card.suit == suit then suit_cards.push(card) end}

      suit_cards.first
    end

    def suit_cards(suit)
      suit_cards = []
      self.sort

      @cards.each do |card|
        if card.suit == suit then suit_cards.push(card.rank) end
      end

      suit_cards
    end

    def belote?
      SUITS.each do |suit|
        suit_cards = suit_cards(suit)
        return true if suit_cards.include? :king and suit_cards.include? :queen
      end
      false
    end

    def first_check(suit_cards, n)
      i, yes = 0, false
      while i + n < RANKS.length
        yes = true if second_check(suit_cards, i, n)
        i += 1
      end
      return yes
    end

    def second_check(suit_cards, i, n)
      suit_cards.all? {|i| (i..i + n).include?(RANK_ORDER[i])}
    end

    def tierce?
      SUITS.each do |suit|
        suit_cards = suit_cards(suit)
        result = first_check(suit_cards, 3)
        return true if result
      end
      return false
    end

    def quarte?
      SUITS.each do |suit|
        suit_cards = suit_cards(suit)
        result = first_check(suit_cards, 4)
        return true if result
      end
      return false
    end

    def quint?
      SUITS.each do |suit|
        suit_cards = suit_cards(suit)
        result = first_check(suit_cards, 5)
        return true if result
      end
      return false
    end

    def carre_of_jacks?
      count = 0
      @cards.each { |card| count += 1 if card.rank == :jack }

      count == 4
    end

    def carre_of_nines?
      count = 0
      @cards.each { |card| count += 1 if card.rank == 9 }

      count == 4
    end

    def carre_of_aces?
      count = 0
      @cards.each { |card| count += 1 if card.rank == :ace }

      count == 4
    end
  end
end

class SixtySixDeck < Deck
  RANKS = {
            9 => ["9", 1],
            :jack => ["Jack", 2],
            :queen => ["Queen", 3],
            :king => ["King", 4],
            10 => ["10", 5],
            :ace => ["Ace", 6]
          }

  def initialize(cards = [])
    @deck_size = 24
    @hand_size = 6
    @ranks = RANKS

    super
  end

  class Hand < Hand
    def suit_cards(suit)
      suit_cards = []
      self.sort

      @cards.each do |card|
        if card.suit == suit then suit_cards.push(card.rank) end
      end

      suit_cards
    end

    def first_check(suit, trump_suit)
      unless suit == trump_suit
        color = suit_cards(suit)
        return true if color.include? :king and color.include? :queen
      end
    end

    def twenty?(trump_suit)
      SUITS.each do |suit|
        return true if first_check(suit, trump_suit)
      end
      false
    end

    def second_check(suit, trump_suit)
      if suit == trump_suit
        color = suit_cards(suit)
        return true if color.include? :king and color.include? :queen
      end
    end

    def forty?(trump_suit)
      SUITS.each do |suit|
        return true if second_check(suit, trump_suit)
      end
      false
    end
  end
end
