class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end
end

# Adding a play method to the Bingo clase would override
# the game method in the Game class for instances of Bingo.
