#!/usr/bin/env ruby
#
# Usage: push.rb JSON_MESSAGE
#
# ex) ./push.rb '{"aps":{"badge":128,"alert":"This is test message from ruby"}}'
#
# This code supports Ruby 1.8.x only.
#

require 'socket'
require 'openssl'

key = ["139d2c11 53ba2124 4ce35ced 00c76ddd d3449d5f 7dc46d2a a316143c 46de8fd7".delete(' ')].pack('H*')
# - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken

message = ARGV.shift
notification_packet = [0, 0, 32, key, 0, message.size, message].pack("ccca*cca*")

context = OpenSSL::SSL::SSLContext.new
context.cert = OpenSSL::X509::Certificate.new(File.read('ssl_certificates/client-cert.pem'))
context.key = OpenSSL::PKey::RSA.new(File.read('ssl_certificates/client-cert.pem'))
# openssl pkcs12 -in mycert.p12 -out client-cert.pem -nodes -clcerts

sock = TCPSocket.new('gateway.sandbox.push.apple.com', 2195)
ssl = OpenSSL::SSL::SSLSocket.new(sock,context)
ssl.connect
ssl.write(notification_packet)
ssl.close
sock.close

