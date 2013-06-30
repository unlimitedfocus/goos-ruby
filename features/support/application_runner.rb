require "main"

class ApplicationRunner
  SNIPER_ID = "sniper@localhost"
  SNIPER_PASSWORD = "sniper"

  def start_bidding_in auction
    @item_id = auction.item_id
		@last_price = 0
		@last_bid = 0
    @application = Main.main SNIPER_ID, SNIPER_PASSWORD, @item_id
    wait_for_app_to_start
    wait_for_status "", @last_price, @last_bid, SniperState::JOINING.to_s
  end

  def stop
    @application.stop
  end

  def bidding? last_price, last_bid
		@last_price, @last_bid = last_price, last_bid
    wait_for_status @item_id, @last_price, @last_bid, SniperState::BIDDING.to_s
  end

  def winning_auction?
    wait_for_status @item_id, @last_bid, @last_bid, SniperState::WINNING.to_s
  end

  def has_lost_auction?
    wait_for_status @item_id, @last_price, @last_bid, SniperState::LOST.to_s
  end

  def has_won_auction?
    wait_for_status @item_id, @last_bid, @last_bid, SniperState::WON.to_s
  end

  private

  def window
    @application.main_window
  end

  def wait_for_app_to_start
    Timeout.timeout 10 do
      sleep 0.01 until @application.main_window.title == "Auction sniper"
    end
  end

  def wait_for_status *columns
    Timeout.timeout 2 do
      sleep 0.01 until displayed_columns == columns
      return true
    end
  rescue Timeout::Error
    fail %{Expected displayed status to be "#{columns}", but was #{displayed_columns}}
  end

  def displayed_columns
    window.child.model.n_columns.times.map {|n| window.child.model.iter_first[n]}
  end
end
