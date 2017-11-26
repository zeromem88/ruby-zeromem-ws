require 'zeromem/ws'

server = Zeromem::Ws::WsHeavy.new :host => 'localhost', :port => 9789, :node_id => "server"
server.dispatcher.handle('method') { |i|
  puts "server: #{i}"
  "#{i}".upcase
}
server.listen

client = Zeromem::Ws::WsHeavy.new :node_id => "client", :timeout => 8000

0.upto(50000) { |i| 
  puts "#{i}" 
  puts client.invoke "ws://localhost:9789", "method", "Hello World" 
}