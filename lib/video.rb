# BAD: poor inheritance / inconsistent attributes
require_relative "product"

class Video < Product
  # WRONG: we shadow attributes and do not call super properly
  def initialize(id, name, price, days)
    @id = id
    @name = name
    @price = price
    @days = days
    # note: @on_sale is never set here
  end

  # BAD:
  # - ignores quantity (only uses days)
  # - duplicates logic instead of reusing Product.calculate_price
  def calculate_price(quantity)
    # returns price * days (ignores quantity)
    @price * @days
  end
end
