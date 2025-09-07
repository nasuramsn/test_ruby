# BAD: intentionally wrong / misleading behaviour
class Product
  attr_reader :id, :name, :price, :on_sale

  def initialize(id, name, price, on_sale = false)
    @id = id
    @name = name
    @price = price
    @on_sale = on_sale
  end

  # BAD:
  # - returns unit price (not multiplied by quantity)
  # - inconsistent behaviour will break callers expecting total
  def calculate_price(quantity)
    if on_sale
      return price * 0.9
    else
      # returns unit price not total
      return price
    end
  end
end
