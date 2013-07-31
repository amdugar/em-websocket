require 'em-websocket'
def mousepress(msg)
  x=msg.split(' ').last.split('&').first.to_i
  y=msg.split(' ').last.split('&').last.to_i
  puts x
  puts y
  system("./osxautomation \"mousewarp #{x} #{y}\"");
  system("./osxautomation \"mouseclick 1\"");
end
def mouserelease(msg)
  system("./osxautomation \"mouseup 1\"");
end
def keypress(msg)
  key = msg.split(' ').last
  system("./osxautomation \"hit #{key}\"")
end
def keyrelease(msg)
  key = msg.split(' ').last;
end
EM.run {
  EM::WebSocket.run(:host => "0.0.0.0", :port => 8080) do |ws|
    ws.onopen { |handshake|
      puts "WebSocket connection open"

      # Access properties on the EM::WebSocket::Handshake object, e.g.
      # path, query_string, origin, headers

      # Publish message to the client
      #ws.send "Hello Client, you connected to #{handshake.path}"
    }

    ws.onclose { puts "Connection closed" }

    ws.onmessage { |msg|
      puts "Recieved message: #{msg}"
      case msg.split(' ').first
      when "keypress"
        keypress(msg)
      when "keyrelease"
        keyrelease(msg)
      when "mousepress"
        mousepress(msg)
      when "mouserelease"
        mouserelease(msg)
      end
      #ws.send "Pong: #{msg}"
    }
  end
}
