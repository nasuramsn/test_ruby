# BAD: unclear premium handling and points not initialized
class User
  attr_reader :name
  attr_accessor :points

  def initialize(name, premium = false, points = 0)
    @name = name
    @premium = premium
    @points = points  # total * 0.01 if premium, it will be double
  end

  def premium?
    @premium
  end

  def calc_points(total)
    temp_total = (total * 0.01).round
    logger = Logger.new(STDOUT)
    logger.debug("temp_total #{temp_total}")
    @points = @premium ? temp_total * 2 : temp_total
    logger.debug("@points #{@points}")
  end
end
