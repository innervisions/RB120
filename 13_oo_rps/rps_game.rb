class Move
  VALUES = %w(rock paper scissors)

  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
  end
end

class Player
  attr_accessor :move, :name

  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    name = nil
    loop do
      puts "What's your name?:"
      name = gets.chomp
      break unless name.empty?
      puts 'Sorry, must enter a value.'
    end
    self.name = name
  end

  def choose
    choice = nil
    loop do
      puts 'Please choose rock, paper, or scissors:'
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts 'Sorry, invalid choice.'
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  COMPUTER_NAMES = %w(R2D2 Marvin HAL Compy)

  def set_name
    self.name = COMPUTER_NAMES.sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts 'Welcome to Rock, Paper, Scissors!'
  end

  def display_goodbye_message
    puts 'Thank you for playing Rock, Paper, Scissors. Good bye!'
  end

  def display_moves
    puts "#{human.name} chose #{@human.move}."
    puts "#{computer.name} chose #{@computer.move}."
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} wins!"
    elsif human.move < computer.move
      puts "#{computer.name} wins."
    else
      puts "It's a tie."
    end
  end

  def play_again?
    answer = nil
    loop do
      puts 'Would you like to play again? (y/n):'
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer[0])
      puts 'Sorry, must be y or n.'
    end
    answer == 'y'
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
