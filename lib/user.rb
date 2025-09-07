# BAD: unclear premium handling and points not initialized
class User
  attr_reader :name
  attr_accessor :points

  def initialize(name, premium = false)
    @name = name
    # premium stored as given, but no predicate method premium?
    @premium = premium
    # points intentionally left uninitialized (nil) for buggy behaviour
  end

  # BAD: inconsistent API (no premium? convenience method)
  def premium
    @premium
  end
end
