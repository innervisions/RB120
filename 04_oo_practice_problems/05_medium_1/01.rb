class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end

# Ben is correct. attr_reader creates a getter method for the
# instance variable @balance, making it accessible without the @.
