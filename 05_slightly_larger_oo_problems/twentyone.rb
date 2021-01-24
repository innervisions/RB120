class Card
  SUITS = %w(♠ ♣ ♥ ♦)
  RANKS = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} #{suit}"
  end

  def ace?
    rank == 'A'
  end

  def point_value
    if rank == 'A'
      11
    elsif rank.to_i == 0
      10
    else
      rank.to_i
    end
  end
end

class Deck
  def initialize
    @cards = Card::SUITS.each_with_object([]) do |suit, deck|
      Card::RANKS.each do |rank|
        deck << Card.new(rank, suit)
      end
    end.shuffle
  end

  def deal_one
    @cards.pop
  end

  def reset!
    initialize
  end
end

module Hand
  CEILING = 21

  def show_hand
    puts "#{name} has #{format_hand}. (Total: #{total})"
  end

  def total
    total = cards.map(&:point_value).sum
    cards.select(&:ace?).count.times { total -= 10 if total > CEILING }
    total
  end

  def busted?
    total > CEILING
  end

  private

  def format_hand
    case cards.size
    when 1 then cards[0].to_s
    when 2 then "#{cards[0]} and #{cards[1]}"
    else "#{cards[0..-2].join(', ')} and #{cards[-1]}"
    end
  end
end

class Participant
  include Hand
  attr_reader :name, :cards

  def initialize
    @cards = []
    set_name
  end

  def to_s
    name
  end

  def reset!
    self.cards = []
  end

  def add_card(card)
    cards << card
  end

  private

  attr_writer :cards
end

class Player < Participant
  def show_flop
    show_hand
  end

  def choice
    loop do
      puts 'Would you like to (h)it or (s)tay?:'
      choice = gets.chomp.downcase
      unless choice.empty?
        return 'h' if ['hit', 'h'].include?(choice)
        return 's' if ['stay', 's'].include?(choice)
      end
      puts "That's not a valid choice."
    end
  end

  private

  def valid_name?(name)
    /\A\S+\z/.match(name) || /\A\S+\s{1}\S+\z/.match(name)
  end

  def set_name
    name = nil
    loop do
      puts "What's your name?:"
      name = gets.chomp
      break if valid_name?(name)
      puts 'Please enter a valid name.'
    end
    @name = name
  end
end

class Dealer < Participant
  DEALER_NAMES = %w(Dixon Volvox Anetha Tiga Umfang Nina)

  def show_flop
    puts "#{name} has #{cards[0]} and an unknown card."
  end

  private

  def set_name
    @name = DEALER_NAMES.sample
  end
end

class TwentyOne
  def start
    loop do
      play_round
      break unless play_again?
      reset_round
    end
    display_goodbye_message
  end

  private

  attr_reader :player, :dealer, :deck

  def initialize
    clear_screen
    display_welcome_message
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def play_round
    deal_hands
    player_turn
    if player.busted?
      display_busted
      return
    end
    dealer_turn
    dealer.busted? ? display_busted : display_result
  end

  def deal_hands
    2.times do
      player.add_card(deck.deal_one)
      dealer.add_card(deck.deal_one)
    end
  end

  def player_turn
    while player.total < Hand::CEILING
      show_flops
      break if player.choice == 's'
      player.add_card(deck.deal_one)
    end
  end

  def dealer_turn
    loop do
      break if dealer.total >= 17
      dealer.add_card(deck.deal_one)
    end
  end

  def show_flops
    clear_screen
    dealer.show_flop
    player.show_flop
    puts '-' * 35
  end

  def show_hands
    clear_screen
    dealer.show_hand
    player.show_hand
    puts '-' * 35
  end

  def display_busted
    if player.busted?
      show_flops
      puts "Looks like #{player} busted. #{dealer} wins."
    elsif dealer.busted?
      show_hands
      puts "#{dealer} busted! #{player} wins!"
    end
  end

  def display_result
    show_hands
    puts "#{dealer}'s hand is worth #{dealer.total}."
    puts "#{player}'s hand is worth #{player.total}."
    display_round_winner
  end

  def display_round_winner
    if player.total > dealer.total
      puts "#{player} wins!"
    elsif dealer.total > player.total
      puts "#{dealer} wins."
    else
      puts "It's a push."
    end
  end

  def reset_round
    player.reset!
    dealer.reset!
    deck.reset!
  end

  def display_welcome_message
    puts 'Welcome to Twenty One!'
  end

  def display_goodbye_message
    puts 'Thank you for playing Twenty One!'
  end

  def play_again?
    answer = nil
    puts
    loop do
      puts 'Would you like to play again? (y/n):'
      answer = gets.chomp.downcase
      break if ['y', 'n', 'yes', 'no'].include?(answer)
      puts 'Sorry, must be y or n.'
    end
    ['y', 'yes'].include?(answer)
  end

  def clear_screen
    system('clear') || system('clr')
  end
end

TwentyOne.new.start
