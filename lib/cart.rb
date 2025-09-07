# BAD: inconsistent item keys, wrong math, fragile receipt and points logic
require 'logger'

class Cart
  def initialize(user)
    @items = []
    @user = user
  end

  def add(product, quantity)
    @items << { product: product, quantity: quantity }
  end

  def total_price
    total = 0
    # logger = Logger.new(STDOUT)
    @items.each do |i|
      total += ((i[:product].calculate_price(i[:quantity]) * i[:quantity]).round rescue 0)
    end
    total
  end

  def checkout
    total = total_price
    @user.calc_points(total)
    total
  end

  def receipt
    lines = []
    @items.each do |i|
      subtotal = ((i[:product].calculate_price(i[:quantity]) * i[:quantity]).round rescue 0)
      lines << "#{i[:product].name} x#{i[:quantity]} = #{subtotal}円"
    end
    total = total_price
    lines << "TOTAL: #{total}円"
    @user.calc_points(total)
    # BAD: Points may be float (e.g. 11.0) and printed as such
    lines << "Points Earned: #{(@user.points || 0)}"
    lines.join("\n")
  end
end
