class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# When used outside of an instance method, self refers
# to the class itself. In this case self refers to the
# Cat class, and is used to define the class method cats_count.
