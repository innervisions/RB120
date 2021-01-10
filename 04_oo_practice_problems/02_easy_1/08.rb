class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

# self is a reference to the object that the method
# is being called on. This could be an instance of
# the Cat class, or of a subclass of Cat.
