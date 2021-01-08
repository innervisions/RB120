class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end

class Computer
  attr_accessor :template

  def create_template
    self.template = "template 14231"
  end

  def show_template
    self.template
  end
end

# The first class definition assigns the instance variable @template
# directly. In show_template it is accessed with the getter method ommiting
# self because Ruby doesn't require it.

# In the second definition, the setter method is used. This requires
# using self. Without self, Ruby would consider it a local variable
# assignment. In show_template self is used explicitly, although
# this is not neccessary.
