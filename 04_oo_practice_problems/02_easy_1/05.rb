class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

# Pizza has an instance variable, @name, initialized
# in it's initialize method. Instance variaves are always prefixed
# with an @.

pizza = Pizza.new('pepperoni')
orange = Fruit.new('orange')
p pizza.instance_variables
p orange.instance_variables
