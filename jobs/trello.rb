require 'trello'

include Trello

Trello.configure do |config|
  config.developer_public_key = 'f4101665069afd91860b77586cc35dd8'
  config.member_token = '53e16df6190378ecfa16ca10bb4400e2305978b2a092c2baf3173c34b30ebc32'
end

boards = {
  "my-trello-board" => "BbQ4ZDzT",
}

class MyTrello
  def initialize(widget_id, board_id)
    @widget_id = widget_id
    @board_id = board_id
  end

  def widget_id()
    @widget_id
  end

  def board_id()
    @board_id
  end

  def status_list()
    status = Array.new
    Board.find(@board_id).lists.each do |list|
      status.push({label: list.name, value: list.cards.size})
    end
    status
  end
end

@MyTrello = []
boards.each do |widget_id, board_id|
  begin
    @MyTrello.push(MyTrello.new(widget_id, board_id))
  rescue Exception => e
    puts e.to_s
  end
end

SCHEDULER.every '5m', :first_in => 0 do |job|
  @MyTrello.each do |board|
    status = board.status_list()
    send_event(board.widget_id, { :items => status })
  end
end