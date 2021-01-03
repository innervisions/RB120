class Move
  VALUES = %w(rock paper scissors lizard spock)
  ABBREVIATIONS = %w(r p sc l sp)
  MATCHUPS = {
    'rock' => %w(scissors lizard),
    'paper' => %w(rock spock),
    'scissors' => %w(paper lizard),
    'spock' => %w(rock scissors),
    'lizard' => %w(spock paper)
  }

  attr_reader :value

  def self.valid?(choice)
    choice = choice.downcase
    ABBREVIATIONS.each_with_index do |abbreviation, idx|
      return true if choice.start_with?(abbreviation) &&
                     VALUES[idx].start_with?(choice)
    end
    false
  end

  def initialize(abbreviation)
    @value = unabbreviate(abbreviation.downcase)
  end

  def to_s
    @value
  end

  def >(other_move)
    MATCHUPS[value].include?(other_move.value)
  end

  def <(other_move)
    other_move > self
  end

  private

  def unabbreviate(choice)
    ABBREVIATIONS.each_with_index do |abbreviation, idx|
      return VALUES[idx] if choice.start_with?(abbreviation)
    end
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
    @history = []
  end

  def to_s
    name
  end

  def display_history
    puts "#{name}'s move history: #{@history.join(', ')}"
  end

  private

  def record_move
    @history << move
  end
end

class Human < Player
  def set_name
    name = nil
    loop do
      puts "What's your name?:"
      name = gets.chomp
      break if valid_name?(name)
      puts 'Please enter a valid name.'
    end
    self.name = name
  end

  def choose
    choice = nil
    loop do
      puts "Please choose #{joinor(Move::VALUES)}:"
      choice = gets.chomp
      break if Move.valid?(choice)
      puts 'Sorry, invalid choice.'
    end
    self.move = Move.new(choice)
    record_move
  end

  private

  def valid_name?(name)
    /\A\S+\z/.match(name) || /\A\S+\s{1}\S+\z/.match(name)
  end

  def joinor(arr)
    case arr.size
    when 1 then arr[0].to_s
    when 2 then "#{arr[0]} or #{arr[1]}"
    else
      arr[0..-2].join(', ') + ", or #{arr[-1]}"
    end
  end
end

class Computer < Player
  COMPUTER_NAMES = %w(R2D2 Marvin Data)

  def set_name
    self.name = COMPUTER_NAMES.sample
  end

  def choose
    self.move = case name
                when 'Marvin' then Move.new(Move::VALUES[0..2].sample)
                when 'Data'   then Move.new('spock')
                else Move.new(Move::VALUES.sample)
                end
    record_move
  end
end

class RPSGame
  def play
    loop do
      play_match
      break unless play_again?
    end
    human.display_history
    computer.display_history
    display_goodbye_message
  end

  private

  attr_accessor :human, :computer, :round

  WINS_REQUIRED = 5

  def initialize
    clear_screen
    display_welcome_message
    @human = Human.new
    @computer = Computer.new
  end

  def play_round
    human.choose
    computer.choose
    round_winner.score += 1 if round_winner
    display_round_results
    enter_to_continue
  end

  def play_match
    initialize_match
    loop do
      clear_screen
      display_banner
      play_round
      break if match_winner
    end
    display_match_results
  end

  def display_welcome_message
    puts "Welcome to #{game_title}!"
  end

  def display_goodbye_message
    puts "Thank you for playing #{game_title}. Good bye!"
  end

  def display_banner
    puts '*' * 40
    puts game_title
    puts "Round #{round}"
    puts "#{human}: #{human.score}    #{computer}: #{computer.score}"
    puts "Win #{WINS_REQUIRED} rounds to win the match."
    puts '*' * 40
  end

  def round_winner
    if human.move > computer.move
      human
    elsif human.move < computer.move
      computer
    end
  end

  def display_round_results
    puts "#{human} chose #{@human.move}."
    puts "#{computer} chose #{@computer.move}."
    puts round_winner ? "#{round_winner} wins." : "It's a tie."
  end

  def enter_to_continue
    puts 'Press ENTER to continue.'
    gets
  end

  def match_winner
    if human.score >= WINS_REQUIRED
      human
    elsif computer.score >= WINS_REQUIRED
      computer
    end
  end

  def display_match_results
    puts '-' * 30
    puts "#{human} won #{human.score} rounds."
    puts "#{computer} won #{computer.score} rounds."
    puts "#{match_winner} wins the match!"
    puts '-' * 30
  end

  def play_again?
    answer = nil
    loop do
      puts 'Would you like to play again? (y/n):'
      answer = gets.chomp.downcase
      break if ['y', 'n', 'yes', 'no'].include?(answer)
      puts 'Sorry, must be y or n.'
    end
    ['y', 'yes'].include?(answer)
  end

  def initialize_match
    self.round = 0
    human.score = 0
    computer.score = 0
  end

  def game_title
    Move::VALUES.map(&:capitalize).join(', ')
  end

  def clear_screen
    system('clear') || system('clr')
  end
end

RPSGame.new.play
