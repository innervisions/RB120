class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    @quantity = updated_count if updated_count >= 0
  end
end

# needed to add @ to quantity on line 11, to make clear
# that we are dealing with an instance variable, not a local
# variable. Could also change attr_reader to attr_accessor
# and utilize a setter method self.quantity=
