# Place in config.ru
RESPONSE = [200, { 'Content-Type' => 'text/html',
          'Content-Length' => '12' }, [ 'Hello World!' ] ]
# a Callback class
class MyCallbacks
  def initialize env
     @name = env["PATH_INFO"][1..-1]
     @name = "unknown" if(@name.length == 0)
  end
  def on_open
    subscribe :chat
    publish :chat, "#{@name} joined the chat."
  end
  def on_message data
    publish :chat, "#{@name}: #{data}"
  end
  def on_close
    publish :chat, "#{@name} left the chat."
  end
end
# The actual Rack application
APP = Proc.new do |env|
  if(env['rack.upgrade?'] == :websocket)
    env['rack.upgrade'] = MyCallbacks.new(env)
    [200, {}, []]
  else
    RESPONSE
  end
end
# The Rack DSL used to run the application
run APP
