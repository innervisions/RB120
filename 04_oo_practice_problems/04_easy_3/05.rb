class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

tv = Television.new
tv.manufacturer
tv.model

Television.manufacturer
Television.model

# NoMethodError because manufacturer is a class method.
# NoMethod Error because model is an instance method.
