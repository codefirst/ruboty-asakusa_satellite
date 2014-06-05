require 'json'
require 'open-uri'
require 'socket.io-client-simple'

module Ruboty
  module Adapters
    class AsakusaSatellite < Base
      env :ASAKUSA_SATELLITE_URL, "AsakusaSatellite URL (e.g. http://asakusa-satellite.org)"
      env :ASAKUSA_SATELLITE_ROOM, "Room name to join in at first (e.g. general)"
      env :ASAKUSA_SATELLITE_USERNAME, "Account's username (e.g. alice)"
      env :ASAKUSA_SATELLITE_API_KEY, "Account's API Key"

      def run
        connect
        Signal.trap("INT") { exit 1 }
        sleep
      end

      def say(message)
        uri = URI.parse("#{url}/api/v1")
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = uri.scheme == 'https'
        https.verify_mode = OpenSSL::SSL::VERIFY_NONE
        https.start do |conn|
          conn.post(uri.path + "/message", URI.encode_www_form({
            room_id: room,
            api_key: api_key,
            message: message[:body]
          }))
        end
      end

      private

      def client
        info = JSON.parse(open("#{url}/api/v1/service/info.json").read)
        url = info["message_pusher"]["param"]["url"]
        key = info["message_pusher"]["param"]["key"]
        @client ||= SocketIO::Client::Simple::Client.new("#{url}/?app=#{key}")
      end

      def room
        ENV["ASAKUSA_SATELLITE_ROOM"]
      end

      def username
        ENV["ASAKUSA_SATELLITE_USERNAME"]
      end

      def api_key
        ENV["ASAKUSA_SATELLITE_API_KEY"]
      end

      def url
        ENV["ASAKUSA_SATELLITE_URL"]
      end

      def connect
        room_id = room
        robo = robot

        client.on :connect do
          self.emit :subscribe, "as-#{room_id}"
        end

        client.on :message_create do |channel, json|
          message = JSON.parse(json)["content"]
          if (not message.nil?) and (not message["room"].nil?)
            if room_id == message["room"]["id"]
              body = message["body"]
              unless body.nil?
                body.match(/^@([A-Za-z0-9_]+)/)
                message_to = $1
                if message_to
                  robo.receive(
                    body: body,
                    from: message["screen_name"],
                    from_name: message["name"],
                    to: message_to,
                    type: "groupchat"
                  )
                end
              end
            end
          end
        end
        client.connect
      end

    end
  end
end
