Given "an auction of an item is in progress" do
  start_auction_for_item("item-54321")
end

When "I am told the current price, bid increment and high bidder" do
  auction.report_price 1000, 98, "other bidder"
end

When "the auction closes" do
  auction.close
end
