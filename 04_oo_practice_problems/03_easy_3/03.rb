class AngryCat
  def initialize(age, name)
    @age  = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hisssss!!!"
  end
end

tiga = AngryCat.new(3, 'Tiga')
dixon = AngryCat.new(7, 'Dixon')
tiga.name
dixon.name
tiga.hiss
dixon.hiss
