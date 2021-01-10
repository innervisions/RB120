class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    quantity = updated_count if updated_count >= 0
  end
end

# Alyssa's solution would work, changing attr_reader to
# attr_accessor would allow clients of the class to change the quanity
# directly, removing the protections of update_quantity.
