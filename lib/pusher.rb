require 'socket'
require 'openssl'

class Pusher
  
  def self.push(device_token, message, options = {})
    key = [device_token.delete(' ')].pack('H*')
    
    payload = {
      :aps => {
        :alert => message,
        :badge => options[:badge],
        :sound => 'default',
      },
    }.merge(options[:custom])
    
    message = payload.to_json

    notification_packet = [0, 0, 32, key, 0, message.size, message].pack("ccca*cca*")

    context = OpenSSL::SSL::SSLContext.new
    context.cert = OpenSSL::X509::Certificate.new(Settings.push_cert)
    context.key = OpenSSL::PKey::RSA.new(Settings.push_cert)
    # openssl pkcs12 -in mycert.p12 -out client-cert.pem -nodes -clcerts  
    
    sock = TCPSocket.new('gateway.sandbox.push.apple.com', 2195)
    ssl = OpenSSL::SSL::SSLSocket.new(sock,context)
    ssl.connect
    ssl.write(notification_packet)
    ssl.close
    sock.close
  end
  
end