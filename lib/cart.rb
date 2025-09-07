# BAD: inconsistent item keys, wrong math, fragile receipt and points logic
class Cart
  def initialize(user)
    @items = []
    @user = user
  end

  def add(product, quantity)
    # BAD: use different key names than other methods expect (:p/:q)
    @items << { p: product, q: quantity }
  end

  def total_price
    total = 0
    # BAD: this loop expects :product/:quantity keys (mismatch) so often falls back to 0
    @items.each do |i|
      if i[:product] && i[:product].on_sale
        # WRONG: huge discount (50%) and uses mismatched keys
        total += (i[:product].price * 0.5) * i[:quantity]
      elsif i[:product]
        total += i[:product].price * i[:quantity]
      else
        # fallback: tries to use the alternate keys, but inconsistent
        total += (i[:p].calculate_price(i[:q]) rescue 0)
      end
    end
    total
  end

  def checkout
    total = total_price
    # BAD: calculates float points and doesn't floor or convert to integer cleanly
    points = (total * 0.01)
    # BAD: uses premium flag in odd way and may produce floats
    if @user.respond_to?(:premium) && @user.premium
      points = points * 2
    end
    # initialize points if nil — but keep float
    @user.points = (@user.points || 0) + points
    total
  end

  def receipt
    lines = []
    @items.each do |i|
      # BAD: mixed keys, using rescue to avoid hard crash; prints floats with decimals
      prod = i[:product] || i[:p]
      qty  = i[:quantity] || i[:q]
      subtotal = (prod.calculate_price(qty) rescue 0)
      lines << "#{prod.name} x#{qty} = #{subtotal}円"
    end
    lines << "TOTAL: #{total_price}円"
    # BAD: Points may be float (e.g. 11.0) and printed as such
    lines << "Points Earned: #{(@user.points || 0)}"
    lines.join("\n")
  end
end
