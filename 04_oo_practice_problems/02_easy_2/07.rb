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

# @@cats_count is a class variable that represents
# the number of instances of Cat that have been created.
# It is initialized at 0, and incremented by 1 each time a Cat
# object is created.
puts Cat.cats_count # 0
Cat.new('Tabby')
Cat.new('Tabby')
Cat.new('Siamese')
puts Cat.cats_count # 3
