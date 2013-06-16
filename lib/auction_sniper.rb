class AuctionSniper
  def initialize sniper_listener
    @sniper_listener = sniper_listener
  end

  def current_price price, increment
    sniper_listener.sniper_bidding
  end

  def auction_closed
    sniper_listener.sniper_lost
  end

  private

  attr_reader :sniper_listener
end