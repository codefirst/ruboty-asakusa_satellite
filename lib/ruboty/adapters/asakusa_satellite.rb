require 'httparty'
require 'socket.io-client-simple'
HTTParty::Basement.default_options.update(verify: false)

module Ruboty
  module Adapters
    class AsakusaSatellite < Base
      env :ASAKUSA_SATELLITE_URL, "AsakusaSatellite URL (e.g. http://asakusa-satellite.org)"
      env :ASAKUSA_SATELLITE_ROOM, "Room name to join in at first (e.g. general)"
      env :ASAKUSA_SATELLITE_API_KEY, "Account's API Key"

      def run
        connect
        Signal.trap("INT") { exit 1 }
        sleep
      end

      def say(message)
        HTTParty.post("#{url}/api/v1/message", body: {
          room_id: room,
          api_key: api_key,
          message: message[:body]
        })
      end

      def on_message(room_id, robot, json)
        message = JSON.parse(json)["content"]
        if (not message.nil?) and (not message["room"].nil?)
          if room_id == message["room"]["id"]
            body = message["body"]
            unless body.nil?
              body.match(/^@([A-Za-z0-9_]+)/)
              message_to = $1
              robot.receive(
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

      private

      def client
        info = HTTParty.get("#{url}/api/v1/service/info.json")
        url = info["message_pusher"]["param"]["url"]
        key = info["message_pusher"]["param"]["key"]
        @client ||= SocketIO::Client::Simple::Client.new(url, app: key)
      end

      def room
        ENV["ASAKUSA_SATELLITE_ROOM"]
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
        this = self

        client.on :connect do
          self.emit :subscribe, "as-#{room_id}"
        end

        client.on :message_create do |channel, json|
          this.on_message(room_id, robo, json)
        end

        client.connect
      end
    end
  end
end
