# Zeromem::Ws

This is implementation for movitto/rjr websocket Node for JSON-RPC to eliminate  
performance degradation under heavy load (1000s queries per minute).

Current implementation has memory leak which cause CPU overhead accumulation.


## Installation



```ruby
gem 'zeromem-ws'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zeromem-ws

## Usage
```ruby
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
```


Bug reports and pull requests are welcome on GitHub at https://github.com/zeromem88/ruby-zeromem-ws.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
