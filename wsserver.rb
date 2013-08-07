require 'em-websocket'
def mousedown(msg)
  x=msg.split(' ').last.split('&').first.to_i
  y=msg.split(' ').last.split('&').last.to_i
  system("./osxautomation \"mousewarp #{x} #{y}\"");
  system("./osxautomation \"mousedown 1\"");
end
def mouserightclick(msg)
  x=msg.split(' ').last.split('&').first.to_i
  y=msg.split(' ').last.split('&').last.to_i
  system("./osxautomation \"mousewarp #{x} #{y}\"");
  system("./osxautomation \"mouseclick 2\"");
end
def mousedoubleclick(msg)
  x=msg.split(' ').last.split('&').first.to_i
  y=msg.split(' ').last.split('&').last.to_i
  system("./osxautomation \"mousewarp #{x} #{y}\"");
  system("./osxautomation \"mousedoubleclick 1\"");
end
def mouseclick(msg)
  x=msg.split(' ').last.split('&').first.to_i
  y=msg.split(' ').last.split('&').last.to_i
  system("./osxautomation \"mousewarp #{x} #{y}\"");
  system("./osxautomation \"mouseclick 1\"");
end
def mousedrag(msg)
  x=msg.split(' ').last.split('&').first.to_i
  y=msg.split(' ').last.split('&').last.to_i
  system("./osxautomation \"mousedrag #{x} #{y}\"");
  system("./osxautomation \"mouseup #{x} #{y}\"");
end
def mouseup(msg)
  system("./osxautomation \"mouseup 1\"");
end
def mousescrollx(msg)
  length = msg.split(' ').last;
  system("./osxautomation \"mouseScrollX #{length}\"");
end
def mousescrolly(msg)
  length = msg.split(' ').last;
  system("./osxautomation \"mouseScrollY #{length}\"");
end
def keypress(msg)
  puts msg;
  key = msg.gsub('keypress ', '').gsub('true', '1').gsub('false', '0')
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
      when "mouseup"
        mouseup(msg)
      when "mouseclick"
        mouseclick(msg)
      when "mousedoubleclick"
        mousedoubleclick(msg)
      when "mouserightclick"
        mouserightclick(msg)
      when "mousedown"
        mousedown(msg)
      when "mousedrag"
        mousedrag(msg)
      when "mouseScrollX"
        mousescrollx(msg)
      when "mouseScrollY"
        mousescrolly(msg)
      end
      #ws.send "Pong: #{msg}"
    }
  end
}
