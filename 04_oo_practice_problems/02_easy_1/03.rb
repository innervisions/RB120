module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed
  def go_slow
    puts "I am safe and driving slow."
  end
end

# self is a reference to the object whose method
# is being called, in this case an instance of the class Car.
# Car inherits the class method from Object. When called it
# returns the object's class (Car). to_s is called on Car
# in the process of string ineterpolation.
