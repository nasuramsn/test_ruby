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
  # - uses wrong discount factor (0.8 instead of 0.9)
  # - inconsistent behaviour will break callers expecting total
  def calculate_price(quantity)
    if on_sale
      # wrong discount and ignoring quantity on purpose
      return price * 0.8
    else
      # returns unit price not total
      return price
    end
  end
end
