class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]] # diagonals

  def initialize
    @squares = {}
    reset
  end

  def reset
    1.upto(9) { |key| @squares[key] = Square.new }
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      return squares[0].marker if three_identical_markers?(squares)
    end
    nil
  end

  def critical_square_key(marker_offense, marker_defense)
    key = find_critical_square_key(marker_offense)
    key ||= find_critical_square_key(marker_defense)
    key
  end

  def someone_won?
    !!winning_marker
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def draw
    puts "     |     |   "
    puts "  #{@squares[1]}  |  #{@squares[2]}  " \
         "|  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  " \
         "|  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  " \
         "|  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).map(&:marker)
    markers.size == 3 && markers.uniq.size == 1
  end

  def critical_square_key_in_line(line, marker)
    key = @squares.select do |k, v|
      line.include?(k) && v.marker == Square::INITIAL_MARKER
    end.keys.first
    return key if @squares.values_at(*line).map(&:marker).count(marker) == 2
  end

  def find_critical_square_key(marker)
    key = nil
    WINNING_LINES.each do |line|
      key = critical_square_key_in_line(line, marker)
      break if key
    end
    key
  end
end

class Square
  INITIAL_MARKER = ' '
  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker
  attr_accessor :name, :score

  def initialize(marker)
    @marker = marker
    @score = 0
  end

  def to_s
    name
  end
end

class Human < Player
  def initialize
    @name = set_name
    super(set_marker)
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
    puts
    name
  end

  def set_marker
    input = nil
    loop do
      puts "Would you like to play as 'X' or 'O'?:"
      input = gets.chomp.upcase
      break if ['X', 'O'].include?(input)
      puts "That's not a valid choice."
    end
    input
  end
end

class Computer < Player
  COMPUTER_NAMES = %w(R2D2 C-3PO Marvin Data Kraftwerk Cybotron)

  def initialize(marker)
    @name = COMPUTER_NAMES.sample
    super(marker)
  end
end

class TTTGame
  WINS_REQUIRED = 5

  def play
    loop do
      play_match
      break unless play_again?
      reset_match
    end
    display_goodbye_message
  end

  private

  attr_reader :board, :human, :computer
  attr_accessor :round, :current_player

  def initialize
    clear_screen
    display_welcome_message
    @board = Board.new
    @human = Human.new
    @computer = (human.marker == 'X' ? Computer.new('O') : Computer.new('X'))
    @current_player = random_player
    @round = 1
  end

  def play_match
    loop do
      play_round
      reset_round
      break if match_winner
    end
    display_match_result
  end

  def play_round
    display_gamestate
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      display_gamestate if human_turn?
    end
    display_round_result
    round_winner.score += 1 if round_winner
    enter_to_continue
  end

  def human_turn?
    current_player == human
  end

  def current_player_moves
    if human_turn?
      human_moves
      self.current_player = computer
    else
      computer_moves
      self.current_player = human
    end
  end

  def round_winner
    return human if board.winning_marker == human.marker
    return computer if board.winning_marker == computer.marker
  end

  def match_winner
    return human if human.score == WINS_REQUIRED
    return computer if computer.score == WINS_REQUIRED
  end

  def human_moves
    square = nil
    loop do
      puts "Choose a square (#{joinor(board.unmarked_keys)}):"
      square = gets.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end
    board[square] = human.marker
  end

  def computer_moves
    key = board.critical_square_key(computer.marker, human.marker)
    key ||= 5 if board.unmarked_keys.include?(5)
    key ||= board.unmarked_keys.sample
    board[key] = computer.marker
  end

  def enter_to_continue
    puts 'Press ENTER to continue.'
    gets
  end

  def display_welcome_message
    puts 'Welcome to Tic Tac Toe!'
    puts
  end

  def display_goodbye_message
    puts 'Thank you for playing Tic Tac Toe. Goodbye!'
  end

  def display_board
    puts "#{human} is #{human.marker}. #{computer} is #{computer.marker}."
    puts
    board.draw
    puts
  end

  def display_scores
    puts "Round #{round}"
    puts '*' * 10
    puts "#{human}: #{human.score}   #{computer}: #{computer.score}"
    puts "Win #{WINS_REQUIRED} rounds to win the match."
    puts '-' * 40
  end

  def display_gamestate
    clear_screen
    display_scores
    display_board
  end

  def display_round_result
    display_gamestate
    puts case round_winner
         when human then "#{human} wins!"
         when computer then "#{computer} wins."
         else "It's a tie."
         end
  end

  def display_match_result
    puts "#{human} won #{human.score}."
    puts "#{computer} won #{computer.score}."
    puts "#{match_winner} wins the match!"
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

  def random_player
    [human, computer].sample
  end

  def reset_round
    board.reset
    self.current_player = random_player
    self.round += 1
  end

  def reset_match
    self.round = 1
    human.score = 0
    computer.score = 0
  end

  def display_play_again_message
    puts "Let's play again!"
    puts
  end

  def clear_screen
    system('clear') || system('clr')
  end

  def joinor(arr, punctuation = ', ', conjunction = 'or')
    case arr.size
    when 1 then arr[0].to_s
    when 2 then "#{arr[0]} #{conjunction} #{arr[1]}"
    else
      arr[0..-2].join(punctuation) + "#{punctuation}#{conjunction} #{arr[-1]}"
    end
  end
end

TTTGame.new.play
