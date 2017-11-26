require 'zeromem/ws'

server = RJR::Nodes::WS.new :host => 'localhost', :port => 9789, :node_id => "server"
server.dispatcher.handle('method') { |i|
  puts "server: #{i}"
  "#{i}".upcase
}
server.listen

client = RJR::Nodes::WS.new :node_id => "client", :host => 'localhost', :port => 9666
puts client.invoke "ws://localhost:9789", "method", "Hello World"