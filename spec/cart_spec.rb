require "rspec"
require_relative "../lib/product"
require_relative "../lib/video"
require_relative "../lib/user"
require_relative "../lib/cart"

RSpec.describe "Shopping System" do
  let(:normal_user) { User.new("Taro") }
  let(:premium_user) { User.new("Hanako", true) }
  let(:cart) { Cart.new(normal_user) }
  let(:premium_cart) { Cart.new(premium_user) }

  let(:apple) { Product.new(1, "Apple", 100) }
  let(:banana) { Product.new(2, "Banana", 200, true) } # セール品
  let(:movie) { Video.new(3, "Avengers", 300, 3) }

  it "calculates total price with products" do
    cart.add(apple, 2)   # 200
    cart.add(banana, 1)  # 180
    expect(cart.total_price).to eq(380)
  end

  it "calculates total price with video rental" do
    cart.add(movie, 1)   # 900
    expect(cart.total_price).to eq(900)
  end

  it "issues receipt with all items and points" do
    cart.add(apple, 2)
    cart.add(movie, 1)
    receipt = cart.receipt
    expect(receipt).to include("Apple x2 = 200円")
    expect(receipt).to include("Avengers x1 = 900円")
    expect(receipt).to include("TOTAL: 1100円")
    expect(receipt).to include("Points Earned: 11")
  end

  it "adds normal points to user on checkout" do
    cart.add(apple, 10) # 1000円
    cart.checkout
    expect(normal_user.points).to eq(10) # 1% 還元
  end

  it "adds double points for premium users" do
    premium_cart.add(apple, 10) # 1000円
    premium_cart.checkout
    expect(premium_user.points).to eq(20) # 2倍
  end
end
